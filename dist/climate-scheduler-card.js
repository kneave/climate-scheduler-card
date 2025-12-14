/**
 * Climate Scheduler Card - Standalone Version
 * Requires Climate Scheduler integration to be installed for backend services
 */

class ClimateSchedulerCard extends HTMLElement {
  static getConfigElement() { return null; }
  static getStubConfig() { return {}; }

  constructor() {
    super();
    this._config = {};
    this._hass = null;
    this._rendered = false;
  }

  setConfig(config) {
    this._config = config || {};
  }

  set hass(hass) {
    this._hass = hass;
    if (this.isConnected && !this._rendered) {
      this._doRender();
    }
  }

  connectedCallback() {
    if (this._hass && !this._rendered) {
      this._doRender();
    }
  }

  async _doRender() {
    this._rendered = true;
    
    if (!this.shadowRoot) {
      const shadow = this.attachShadow({ mode: 'open' });
      const style = document.createElement('style');
      style.textContent = `:host { display: block; } .wrapper { width: 100%; min-height: 400px; }`;
      shadow.appendChild(style);
      
      this._container = document.createElement('div');
      this._container.className = 'wrapper';
      shadow.appendChild(this._container);
    }

    await this._loadPanel();
  }

  async _loadPanel() {
    // Check if integration is installed
    if (!this._hass) {
      this._container.innerHTML = '<div style="padding: 16px; color: orange;">Waiting for Home Assistant connection...</div>';
      return;
    }

    // Check if climate_scheduler domain services exist
    const hasIntegration = this._hass.services?.climate_scheduler !== undefined;

    if (!hasIntegration) {
      this._container.innerHTML = `
        <div style="padding: 16px; color: red; border: 1px solid red; border-radius: 4px; margin: 16px;">
          <h3>❌ Climate Scheduler Integration Not Found</h3>
          <p>This card requires the Climate Scheduler integration to be installed.</p>
          <p>Install it from HACS or visit: 
            <a href="https://github.com/kneave/climate-scheduler" target="_blank" style="color: #03a9f4;">
              github.com/kneave/climate-scheduler
            </a>
          </p>
        </div>
      `;
      return;
    }

    // Load panel module from local community path
    try {
      const basePath = '/local/community/climate-scheduler-card';
      const scriptUrl = import.meta.url;
      let version = new URL(scriptUrl).searchParams.get('hacstag');
      
      // If no hacstag, load version from .version file
      if (!version) {
        try {
          const response = await fetch(`${basePath}/.version`);
          if (response.ok) {
            version = await response.text();
          }
        } catch (e) {
          console.warn('Failed to load .version file:', e);
        }
      }

      
      if (!customElements.get('climate-scheduler-panel')) {
        await import(`${basePath}/panel.js?v=${version}`);
      }
    } catch (e) {
      this._container.innerHTML = `
        <div style="padding: 16px; color: red;">
          Failed to load panel module: ${e.message}<br>
          Make sure the card is properly installed in /config/www/community/climate-scheduler-card/
        </div>
      `;
      return;
    }

    const tag = 'climate-scheduler-panel';
    if (!customElements.get(tag)) {
      this._container.innerHTML = '<div style="padding: 16px; color: orange;">Panel component not registered. Please reload the page.</div>';
      return;
    }

    this._container.innerHTML = '';
    const el = document.createElement(tag);
    if (this._hass) el.hass = this._hass;
    el.setAttribute('embed', '1');
    this._container.appendChild(el);
  }

  getCardSize() {
    return 10;
  }
}

if (!customElements.get('climate-scheduler-card')) {
  customElements.define('climate-scheduler-card', ClimateSchedulerCard);
}

window.customCards = window.customCards || [];
const exists = window.customCards.some((c) => c.type === 'climate-scheduler-card');
if (!exists) {
  window.customCards.push({
    type: 'climate-scheduler-card',
    name: 'Climate Scheduler Card',
    description: 'Full Climate Scheduler UI as a Lovelace card',
    preview: false,
  });
}

export {};
