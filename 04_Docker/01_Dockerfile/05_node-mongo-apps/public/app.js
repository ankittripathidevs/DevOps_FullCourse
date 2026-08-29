const form = document.getElementById("signupForm");
const button = document.getElementById("formBtn");
const message = document.getElementById("message");

form.addEventListener("submit", async (event) => {
  // Stop normal form submission
  event.preventDefault();

  // Get form data
  const formData = new FormData(form);
  const user = Object.fromEntries(formData.entries());

  // Clear previous message
  message.textContent = "";
  message.className = "message";

  // Loading state
  button.disabled = true;
  button.classList.add("loading");

  try {
    // Send data to Node.js
    const response = await fetch("/addUser", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(user),
    });

    // Convert response to JSON
    const data = await response.json();

    // Check API response
    if (!response.ok) {
      throw new Error(data.message || "Unable to create account.");
    }

    // Success message
    message.textContent = `✅ ${data.message} Welcome, ${data.username}!`;
    message.classList.add("success");

    // Clear form
    form.reset();
  } catch (error) {
    console.error(error);

    // Error message
    message.textContent = `❌ ${error.message || "Something went wrong."}`;
    message.classList.add("error");
  } finally {
    // Remove loading state
    button.disabled = false;
    button.classList.remove("loading");
  }
});

