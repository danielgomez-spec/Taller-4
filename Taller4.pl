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



% --- PROCESAMIENTO DE LISTAS Y NLP ---

% 1. Fusionar inventarios de dos personajes usando append/3 (2.3)
fusionar_equipo(P1, P2, EquipoFusionado) :-
    inventario(P1, L1),
    inventario(P2, L2),
    append(L1, L2, EquipoFusionado).

% 2. Base de conjugación (Adaptación directa de conjugar_verbo/5 en 2.3)
tiempo(presente). tiempo(pasado). tiempo(futuro).
persona(primera). persona(segunda). persona(tercera).
numero(singular). numero(plural).

ser(presente, tercera, singular, "es").
ser(pasado, tercera, singular, "fue").
ser(futuro, tercera, singular, "será").
ser(presente, primera, singular, "soy").
ser(presente, primera, plural, "somos").

% 3. Regla de inferencia con estructura condicional (2.3)
conjugar_accion(Verbo, Tiempo, Persona, Numero, Conjugacion) :-
    tiempo(Tiempo), persona(Persona), numero(Numero),
    (  Verbo = "ser" ->
       ser(Tiempo, Persona, Numero, R),
       Conjugacion = R
    ;  Conjugacion = Verbo ). % Si no es "ser", devuelve el infinitivo

% 4. Generación de reporte narrativo
generar_reporte(Personaje, MisionID, Mensaje) :-
    puede_aceptar(Personaje, MisionID),
    mision(MisionID, Nombre, _, XP),
    conjugar_accion("ser", presente, tercera, singular, FormaVerbal),
    atomic_list_concat([Personaje, FormaVerbal, "capaz de completar", Nombre, "por", XP, "XP"], ' ', Mensaje).


    % --- CONSULTAS DE VALIDACIÓN FINAL (Ejecutar en consola) ---

% 1. Fusión de equipos y filtrado
% ?- fusionar_equipo('Elara', 'Rin', Equipo), member(pocion, Equipo).
% Equipo = [espada, escudo, pocion, varita, grimorio, pocion, amuleto] ; true

% 2. Conjugación con backtracking
%?- conjugar_accion("ser", T, P, N, C).
% Devuelve todas las combinaciones válidas definidas en ser/4.

% 3. Generación de reporte narrativo completo
%?- generar_reporte('Elara', m2, Msg).
% Msg = 'Elara es capaz de completar Cueva del Dragón por 120 XP'.

% 4. Demostración de error controlado (Unificación vs Aritmética)
%?- X = 10, X == 10.     true (ya instanciada)
%?- Y == 10.             false (variable no instanciada, regla 2.2)
%?- Z =:= 10.            ERROR: Arguments are not sufficiently instantiated (2.2)