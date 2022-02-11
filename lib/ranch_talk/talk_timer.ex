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

  def tick(widget, %{seconds_to_count: seconds_to_count, done_message: done_message} = state) do
    if seconds_to_count < 1 do
      set_html(widget, done_message)
      Kino.JS.Live.cast(widget, :timer_finished)
    else
      new_state =
        state
        |> Map.put(:seconds_to_count, seconds_to_count - 1)
        |> update_state_html()

      set_html(widget, state.html)
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
    minutes = seconds |> div(60) |> to_string()
    seconds = seconds |> rem(60) |> to_string() |> String.pad_leading(2, "0")
    Map.put(state, :html, Enum.join([minutes, ":", seconds]))
  end

  asset "main.js" do
    """
    export function init(ctx, state) {
      ctx.root.innerHTML = state.html;
      ctx.handleEvent("set_html", html => ctx.root.innerHTML = html)
      ctx.handleEvent("timer_finished", message => alert(message))
    }
    """
  end
end
