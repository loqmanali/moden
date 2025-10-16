// Modn PWA Preloader
class ModnAppConfig {
    constructor(config = {}) {
        this.background = config.background || '#ffffff';
        this.foreground = config.foreground || '#000000';
        this.primary = config.primary || '#007bff';
        this.loaderWidget = config.loaderWidget || '<div class="modn-logo">Modn</div>';
        this.transitionDuration = config.transitionDuration || 500;
    }
}

class ModnApp {
    constructor(config) {
        this.config = config;
        this.isLoaded = false;
    }

    loadApp() {
        if (this.isLoaded) return;
        this.isLoaded = true;

        this.#createLoader();
        this.#setupEventListeners();
    }

    #createLoader() {
        // Create main loader container
        const loaderDiv = document.createElement('div');
        loaderDiv.id = 'modn-preloader';
        loaderDiv.className = 'modn-preloader';
        
        // Add loader content
        loaderDiv.innerHTML = this.config.loaderWidget;

        // Append to body
        document.body.appendChild(loaderDiv);

        // Set background
        document.body.style.backgroundColor = this.config.background;

        // Create animated loader bar
        const loaderBarDiv = document.createElement('div');
        loaderBarDiv.className = 'modn-loader-bar';
        loaderDiv.appendChild(loaderBarDiv);

        // Create and inject styles
        this.#createStyleSheet();
    }

    #createStyleSheet() {
        const css = `
            .modn-preloader {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: ${this.config.background};
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
                z-index: 9999;
                transition: opacity ${this.config.transitionDuration}ms ease-out;
            }

            .modn-logo {
                font-size: 2.5rem;
                font-weight: bold;
                color: ${this.config.primary};
                margin-bottom: 2rem;
                text-align: center;
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            }

            .modn-loader-bar {
                width: 200px;
                height: 4px;
                background: rgba(0, 0, 0, 0.1);
                border-radius: 2px;
                overflow: hidden;
                position: relative;
            }

            .modn-loader-bar::after {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(90deg, 
                    transparent, 
                    ${this.config.primary}, 
                    transparent
                );
                animation: modn-loading 1.5s infinite;
            }

            @keyframes modn-loading {
                0% { left: -100%; }
                100% { left: 100%; }
            }

            .modn-preloader.fade-out {
                opacity: 0;
                pointer-events: none;
            }

            @media (prefers-color-scheme: dark) {
                .modn-preloader {
                    background: #1a1a1a;
                }
                .modn-logo {
                    color: #ffffff;
                }
                .modn-loader-bar {
                    background: rgba(255, 255, 255, 0.1);
                }
            }
        `;

        const style = document.createElement('style');
        style.id = 'modn-preloader-style';
        style.textContent = css;
        document.head.appendChild(style);
    }

    #setupEventListeners() {
        // Listen for Flutter app ready
        window.addEventListener('flutter-first-frame', () => {
            this.onAppReady();
        });

        // Fallback timeout
        setTimeout(() => {
            this.onAppReady();
        }, 10000); // 10 seconds max
    }

    onAppReady() {
        const loaderDiv = document.getElementById('modn-preloader');
        if (!loaderDiv) return;

        // Fade out the loader
        loaderDiv.classList.add('fade-out');

        // Remove after transition
        setTimeout(() => {
            if (loaderDiv.parentNode) {
                loaderDiv.remove();
            }
            
            // Remove styles
            const styleSheet = document.getElementById('modn-preloader-style');
            if (styleSheet) {
                styleSheet.remove();
            }
        }, this.config.transitionDuration + 50);
    }

    onThemeChanged(event) {
        const theme = event.detail;
        const background = theme.background || this.config.background;
        const foreground = theme.foreground || this.config.foreground;
        const primary = theme.primary || this.config.primary;
        
        // Store theme in localStorage
        localStorage.setItem('modn.theme.background', background);
        localStorage.setItem('modn.theme.foreground', foreground);
        localStorage.setItem('modn.theme.primary', primary);

        // Update current config
        this.config.background = background;
        this.config.foreground = foreground;
        this.config.primary = primary;
    }
}

// Global exports
globalThis.ModnApp = ModnApp;
globalThis.ModnAppConfig = ModnAppConfig;

// Default configuration
const modnConfig = {
    background: '#ffffff',
    primary: '#007bff',
    loaderWidget: '<div class="modn-logo">Modn</div>',
    transitionDuration: 500
};

// Initialize the preloader
const modnApp = new ModnApp(new ModnAppConfig(modnConfig));

// Start when DOM is ready
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => {
        modnApp.loadApp();
    });
} else {
    modnApp.loadApp();
}