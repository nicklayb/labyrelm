# Labyrelm

Elm implementation of Prim algorithm to generate labyrinth. Only used to learning.

## Why?

I did the Prim Algorithm using C# at University and was wondering how this would be done in functional programming. It has his challenges but, I think, makes a more maintenable program.

### How it works

The Prim Algorithm is a greedy algorithm that finds a minimum spanning tree for a weighted undirected graph [https://en.wikipedia.org/wiki/Prim%27s_algorithm](https://en.wikipedia.org/wiki/Prim%27s_algorithm)

It basically works this way. Suppose a matrix of nodes with east and south bridges like the following

```
# 3 # 6 # 9 #
2   5   2   1
# 1 # 3 # 2 #
4   7   9   3
# 7 # 5 # 3 #
```

- `#` are nodes
- `+` are visited nodes
- `[0-10]` are bridges. The number is their weight.

Starting with any border node (let's say (0, 0)), you browse the visited node the find the lowest edge **that is not connected to an already visited node**. From (0, 0), the lowest is `2` on the south. You mark this bridge as selected and add the node connected to it in the visited node. (It now contains `[(0, 0), (1, 0)]`).

```
+ 3 # 6 # 9 #
|   5   2   1
+ 1 # 3 # 2 #
4   7   9   3
# 7 # 5 # 3 #
```

Then again we browse the visited node the find the lowest bridge. The lowest is the one connected with the (1, 0) node. We mark the bridge as selected and then we add the node connected to it as vissted.


```
+ 3 # 6 # 9 #
|   5   2   1
+ - + 3 # 2 #
4   7   9   3
# 7 # 5 # 3 #
```

Repeat the process until the visited node count matches the total node count. In the end the maze would look like this


```
+ - +   +   +
|       |   |
+ - + - + - +
|           |
+   + - + - +
```


## Start the game

Run the following commands to start the development server

```
npm install
npm run start
```

### Home screen

On the home screen you can enter the size of the grid you want and the seed to use. Once you click the `Create a x by y labyrinth` you'll be redirected to `/game/seed/x/y` where you have a viewport of 3 by 3 on your labyrinth. (The redirection has forced me to learn and use Elm's routing).

### Grid view

Click the Up/Right/Down/Left case to move in the labyrinth to that direction. Once you'll find the end, your emoji will be happy. Gray block are walls and white ones are floor.
