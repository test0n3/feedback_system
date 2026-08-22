// Micro-interaction for rating buttons
document.addEventListener("DOMContentLoaded", () => {
  const ratingButtons = document.querySelectorAll(".rating-btn");

  function setActive(button) {
    // Reset all buttons
    ratingButtons.forEach(b => {
      b.classList.remove("active");
      b.setAttribute("aria-pressed", "false");
    });

    if (!button) return;

    button.classList.add("active");
    button.setAttribute("aria-pressed", "true");

    const radio = document.getElementById(`rating-${button.dataset.value}`);
    if (radio) radio.checked = true;
  }

  ratingButtons.forEach(btn => btn.addEventListener("click", () => setActive(btn)));

  // Restore visual state if the form re-renders with a pre-selected value
  // (e.g. after a validation error round-trip)
  const checked = document.querySelector('input[name="feedback[qualification]"]:checked');
  if (checked) {
    const initialBtn = document.querySelector(`.rating-btn[data-value="${checked.value}"]`);
    setActive(initialBtn);
  }
});
