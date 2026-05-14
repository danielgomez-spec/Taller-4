% --- HECHOS (Base de Conocimiento) ---
personaje('Elara', 5, 100).
personaje('Kael', 3, 80).
personaje('Rin', 7, 120).

mision(m1, 'Bosque de Sombras', 2, 50).
mision(m2, 'Cueva del Dragón', 5, 120).
mision(m3, 'Torre Arcana', 7, 200).

inventario('Elara', [espada, escudo, pocion]).
inventario('Kael', [arco, flechas]).
inventario('Rin', [varita, grimorio, pocion, amuleto]).

requiere(m2, escudo).
requiere(m2, pocion).
requiere(m3, grimorio).
requiere(m3, pocion).


% --- REGLAS ARITMÉTICAS Y RECURSIVAS ---

% 1. Verificación de nivel (Operador relacional >=)
puede_aceptar(Personaje, ID_Mision) :-
    personaje(Personaje, Nivel, _),
    mision(ID_Mision, _, Dificultad, _),
    Nivel >= Dificultad.

% 2. Cálculo recursivo de XP acumulada (Patrón factorial de 2.1)
% Caso base: 0 misiones = 0 XP
xp_acumulada(0, 0).
% Paso recursivo: XP(N) = XP(N-1) + (30 * N)
xp_acumulada(N, Total) :-
    N > 0,
    N1 is N - 1,                % Instanciación obligatoria antes de recursión
    xp_acumulada(N1, Prev),
    Total is Prev + (30 * N).   % Precedencia: * antes de +

% 3. Verificación de inventario con member/2
tiene_requerido(Personaje, Objeto) :-
    inventario(Personaje, Lista),
    member(Objeto, Lista).      % Función built-in (2.3)


% --- REGLAS DE UNIFICACIÓN Y COMPARACIÓN ---

% 1. Detectar personajes del mismo nivel exacto (vs unificación)
mismo_nivel(P1, P2) :-
    personaje(P1, N, _),
    personaje(P2, N, _),
    P1 \== P2.              % \==: falla solo si son el mismo átomo

% 2. Validar balance aritmético estricto
es_balanceado(Personaje) :-
    personaje(Personaje, _, Vida),
    Vida =:= 100.           % =:= exige evaluación aritmética instanciada

