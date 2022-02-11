defmodule RanchTalk.TalkTimer do
  use Kino.JS
  use Kino.JS.Live

  require Logger

  defmodule Opts do
    @ten_minutes_in_seconds 60 * 10

    defstruct done_message: "Timer finished!",
              seconds_to_count: @ten_minutes_in_seconds
  end

  @default_opts %{
    done_message: "Timer finished!",
    seconds_to_count: 600
  }

  @spec new(opts :: Opts.t()) :: Kino.JS.Live.t()
  def new(opts) do
    state =
      @default_opts
      |> Map.merge(opts)
      |> update_state_html()

    Kino.JS.Live.new(__MODULE__, state)
  end

  def set_html(widget, html) do
    Kino.JS.Live.cast(widget, {:set_html, html})
  end

  def get_state(widget) do
    Kino.JS.Live.call(widget, :get_state)
  end

  @impl true
  def init(state, ctx) do
    {:ok, assign(ctx, state)}
  end

  def tick(widget) do
    state = get_state(widget)
    tick(widget, state)
  end

  def tick(widget, %{seconds_to_count: seconds_to_count} = state) do
    new_state =
      state
      |> Map.put(:seconds_to_count, seconds_to_count - 1)
      |> update_state_html()

    set_html(widget, state.html)

    if seconds_to_count < 1 do
      Kino.JS.Live.cast(widget, :timer_finished)
    else
      Process.sleep(1000)
      tick(widget, new_state)
    end
  end

  @impl true
  def handle_connect(ctx) do
    {:ok, ctx.assigns, ctx}
  end

  @impl true
  def handle_cast({:set_html, html}, ctx) do
    broadcast_event(ctx, "set_html", html)
    {:noreply, assign(ctx, html: html)}
  end

  @impl true
  def handle_cast(:timer_finished, ctx) do
    broadcast_event(ctx, "timer_finished", ctx.assigns.done_message)
    {:noreply, ctx}
  end

  @impl true
  def handle_call(:get_state, _from, ctx) do
    {:reply, ctx.assigns, ctx}
  end

  def start(widget) do
    spawn(fn -> tick(widget) end)
    widget
  end

  defp update_state_html(%{seconds_to_count: seconds} = state) do
    minutes = seconds |> div(60) |> double_digit()
    seconds = seconds |> rem(60) |> double_digit()
    Map.put(state, :html, Enum.join([minutes, ":", seconds]))
  end

  defp double_digit(n), do: n |> to_string |> String.pad_leading(2, "0")

  asset "main.js" do
    """
    export function init(ctx, state) {
      const display = document.createElement("div")
      display.style.textAlign = 'center'
      display.style.fontFamily = 'IosevkaLyte, monospace'
      display.style.fontSize = '60px'
      display.style.margin = '0 auto'
      display.style.borderBottom = 'solid 8px rgba(0, 0, 0, 0.25)'
      display.textContent = state.html
      ctx.root.style.display = 'flex'
      ctx.root.appendChild(display)

      ctx.handleEvent("set_html", html => display.textContent = html)
      ctx.handleEvent("timer_finished", message => alert(message))
    }
    """
  end
end
