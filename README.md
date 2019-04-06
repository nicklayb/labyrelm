# Gelm of life

Elm implementation of popular Conway's game of life. Only used to learning.

## Why?

I always loved writing the Game of Life with different languages to learn them, it has some "challenges" that requires some different implementation from a language to another.

### How it works

The Game of life is a cellular automaton by John Horton Conway. [https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life)

This consist of a grid where you have living and dead cells. It evolves according to the following pattern

- If a cell has exactly 3 living neighbors, it becomes alive
- If a cell has exactly 2 living neighbors, it keep it's state
- Otherwise it dies

## Start the game

Run the following commands to start the development server

```
npm install
npm run start
```

### Home screen

On the home screen you can enter the size of the grid you want. Once you click the `Create a x by y game of life grid` you'll be redirected to `/grid/x/y` where you cell grid lives. (The redirection has forced me to learn and use Elm's routing)

### Grid view

Once you're in a grid, you can click on any dead cell in the board to make it live, alive cells will die on click. Once you want to evolve the cell pattern click "Evolve".

#### Auto mode

I'va included an Auto mode to use Elm's subscribtion. It ticks every 100ms, if the automode is enabled, the pattern will evolve automatically. Click the "Start" button to enable it, click "Stop" to disable it.
