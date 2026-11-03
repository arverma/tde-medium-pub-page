const DISCORD_INVITE_URL = "https://discord.gg/qjJCEMT4";

document.querySelectorAll("[data-discord-link]").forEach((link) => {
  if (DISCORD_INVITE_URL === "#") {
    link.hidden = true;
    return;
  }

  link.href = DISCORD_INVITE_URL;
  link.target = "_blank";
  link.rel = "noopener";
});
