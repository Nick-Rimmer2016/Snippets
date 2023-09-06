import time
import winsound
import tkinter as tk
from tkinter.font import Font

class PomodoroTimer:
    def __init__(self, root):
        self.root = root
        self.stop_timer = False
        self.current_timer_id = None
        self.completed_pomodoros = 0
        self.pomodoro_duration = 25 * 60  # 25 minutes for the Pomodoro
        self.break_duration = 5 * 60     # 5 minutes for the break

        self.root.title("Pomodoro Timer")
        self.root.geometry("400x400")

        self.font = Font(family="Helvetica", size=48)

        self.time_label = tk.Label(self.root, text="00:00", font=self.font)
        self.time_label.pack(pady=20)

        self.counter_label = tk.Label(self.root, text=f"Completed Pomodoros: {self.completed_pomodoros}", font=("Helvetica", 16))
        self.counter_label.pack(pady=10)

        self.task_entry = tk.Entry(self.root, font=("Helvetica", 12))
        self.task_entry.pack(pady=5)

        self.start_button = tk.Button(self.root, text="Start Timer", command=self.start_pomodoro)
        self.start_button.pack(pady=10)

        self.stop_button = tk.Button(self.root, text="Stop Timer", command=self.stop_timer_func)
        self.stop_button.pack(pady=10)

        self.reset_button = tk.Button(self.root, text="Reset Timer", command=self.reset_timer)
        self.reset_button.pack(pady=10)

    def play_alert_sound(self):
        duration = 1000  # milliseconds
        frequency = 440  # Hz
        winsound.Beep(frequency, duration)

    def countdown(self, seconds, label):
        if seconds >= 0 and not self.stop_timer:
            mins, secs = divmod(seconds, 60)
            timeformat = '{:02d}:{:02d}'.format(mins, secs)
            label.config(text=timeformat)
            self.current_timer_id = self.root.after(1000, self.countdown, seconds - 1, label)
        elif seconds < 0:
            self.play_alert_sound()
            self.increment_counter()  # Increment counter when a Pomodoro session completes

    def stop_timer_func(self):
        self.stop_timer = True
        if self.current_timer_id is not None:
            self.root.after_cancel(self.current_timer_id)

    def increment_counter(self):
        self.completed_pomodoros += 1
        self.counter_label.config(text=f"Completed Pomodoros: {self.completed_pomodoros}")

        # Store the task description in the list
        task_description = self.task_entry.get()
        self.task_descriptions.append(task_description)

        # Save the task descriptions to file
        self.save_task_descriptions()

        # Clear the task description entry
        self.task_entry.delete(0, tk.END)

    def reset_counter(self):
        self.completed_pomodoros = 0
        self.counter_label.config(text=f"Completed Pomodoros: {self.completed_pomodoros}")
        self.task_descriptions = []

        # Save the task descriptions to file (resetting the file)
        self.save_task_descriptions()

    def reset_timer(self):
        self.stop_timer = True
        if self.current_timer_id is not None:
            self.root.after_cancel(self.current_timer_id)
        self.time_label.config(text="25:00")
        self.reset_counter()
        self.start_pomodoro()

    def start_pomodoro(self):
        self.stop_timer = False
        self.run_pomodoro(self.pomodoro_duration)

    def run_pomodoro(self, duration):
        if not self.stop_timer:
            self.time_label.config(text="Pomodoro - Work time:")
            self.countdown(duration, self.time_label)

            self.time_label.after((duration + 1) * 1000, self.start_break)

    def start_break(self):
        if not self.stop_timer:
            self.play_alert_sound()
            self.time_label.config(text="Break time:")
            self.countdown(self.break_duration, self.time_label)

            self.time_label.after((self.break_duration + 1) * 1000, lambda: self.run_pomodoro(self.pomodoro_duration))

    
if __name__ == "__main__":
    root = tk.Tk()
    timer = PomodoroTimer(root)
    root.mainloop()
