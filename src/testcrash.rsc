module testcrash

import IO;

data T = f(int x) | g(str y);
data T2 = f(int x, str s);

public void stuff(f(x)) {
	println(x);
}

public void stuff(g(y)) {
	println(y);
}

public default void stuff(T t) {
	println("default?");
}