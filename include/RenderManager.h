#ifndef _RENDER_MANAGER_H_
#define _RENDER_MANAGER_H_

#define SCREEN_WIDTH 1920
#define SCREEN_HEIGHT 1080

#include <string>
#include <map>
#include <SDL2/SDL.h>
#include <SDL2/SDL_image.h>
#include <SDL2/SDL_ttf.h>

class RenderManager
{
    public:
        static RenderManager* Instance();
        static void Release();

    public:
        RenderManager();
        ~RenderManager();

        void Render(SDL_Texture* texture, SDL_Rect clip, SDL_Rect pos);

        bool Init();

        SDL_Texture* LoadTexture(std::string path);

        void Clear();
        void Render();
        void RenderTexture(SDL_Texture* texture, SDL_Rect *pos, SDL_Rect *clip);
        void DrawLine(int x1, int y1, int x2, int y2);
        void DrawRect(int x, int y, int width, int height);
        void DrawRect(SDL_Rect rect);
        SDL_Rect RenderText(std::string text, int x, int y, int fontSize=16);
        SDL_Rect RenderWrappedText(std::string text, int x, int y, Uint32 wrapLength, int fontSize=16);
        TTF_Font* GetFont(std::string path, int size);


        void SetWindowSize(int w, int h);

    private:
        static RenderManager* sInstance;

        SDL_Window *mWindow;
        SDL_Renderer *mRenderer;

        std::map<std::string, SDL_Texture*> mTextures;
        std::map<std::string, TTF_Font*> mFonts;
};

#endif
