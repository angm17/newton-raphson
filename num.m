%{
Programa para calcular método de newton-raphson.
Alumno: * Miguel Angel Angarita.
Programa usado: MatLab R2015a

Explicación de algunas funciones las cuales se repiten muchas veces a lo
largo del código, para no explicar una y otra vez para qué sirven, se hará una sola vez:

* isempty: evalúa si una variable de texto está vacía.
* isnan: evalúa si una variable numerica está vacía.
* fprintf: imprime un valor formateado.
* str2double: transforma una variable tipo texto a una variable numerica tipo
double.
* isnumeric: verifica si una variable es numerica.
* break: Rompe un ciclo, en este caso se usó con el ciclo while.
* while(condicion): ejecuta un ciclo mientras se cumpla la condición dada. Si
la condición es "true", se ejecutará para siempre a menos que el usuario
salga de él haciendo un break.

* if(condición): Evalua si se cumple una condición. Si lo hace se ejecuta
un trozo de código.
* else: Si esa condición no se cumple se ejecuta otro trozo de código diferente.

%}
clear, clc %Limpia la consola y la memoria.
fprintf('Cálculo por método Newton-Raphson.\n\n');%Imprimimos en pantalla el mensaje de título.

%{
Comenzando creando un ciclo while, que se repetirá infinitamente hasta que
se cumpla una condición.

Esa condición será que el usuario ingrese la función a evaluar.

%}

while (true) %Comienza el ciclo while.
    funcion = input('Introduzca la función f(x)=','s'); %Pedimos al usuario ingresar la función con la que desea trabajar.
    if (isempty(funcion))%Comprobamos no ingreso nada.
        fprintf('Debes ingresar una función.\n'); %Si no ingresó y la variable funcion está vacia (isempty), imprimimos un mensaje que diga tal.
    else
        break; %Si ingresó algo, hacemos que el ciclo while se "rompa" y nos deje continuar.
    end
    
end%Termina el ciclo while.
%{
Creamos otro while que se ejecutará indefinidamente hasta que se cumpla una
condición.

Esa condición será que si el usuario introduce un intervalo, este tenga que
cumplir el formato A-B.
%}
while (true)
    intervalo = input ('Ingrese el intervalo en el formato A-B en caso de tenerlo: ','s'); %pedimos al usuario insertar el intervalo de estudio, usando un guión como separador entre ellos.
    if (~isempty(intervalo)) %Si la variable intervalo está vacía:
        %{
        Preparamos el regex (expresión regular.)
        Este regex está programado para que el usuario solo pueda insertar
        intervalos que cumplan con el formato A-B. Donde A y B son numeros
        obligatoriamente, puede haber espacios indefinidos entre ellos, ejemplo: A- B,
        A - B. Y solo un guión entre ellos.
%}
        regex = '^(\d+(?:\.\d+)?) *\-{1} *(\d+(?:\.\d+)?)$';
        if (regexp(intervalo, regex)) %procedemos a comprobar la variable intervalo con el regex usando la función regexp de matlab
            intervalo = strsplit(intervalo, '-'); %usamos la función strsplit para cortar el intervalo en el guión, lo cual nos devolverá un arreglo que más adelante asignaremos.
            intervalo_a = intervalo{1};%creamos una variable que guardará el indice cero del arreglo intervalo.
            intervalo_b = intervalo{2};%al igual que arriba, creamos una variable que guarde el indice uno del arreglo intervalo.      
            break;
        else
            fprintf('El intevalo debe ser en formato A-B, ejemplo: 0-4.\n');%Si en la evaluación del regex no se encontró coincidencia, le indicamos al usuario un mensaje.
        end
    else
        break; %Ya que el uso de un intervalo no es obligado, si el usuario no ha ingresado uno, hacemos que el while se "rompa" y se siga ejecutando la otra parte del código.
    end
end

%{
Creamos un nuevo ciclo while que se ejecutará de forma indefinida hasta que
se cumpla unas condiciones.

Esas condiciones son: Que el usuario ingrese un valor para Xo. Que ese
valor sea un numero.
%}
while(true)
    xo = str2double(input('Ingrese el valor de Xo en caso de tenerlo, de lo contrario deje en blanco: Xo=','s')); %Pedimos al usuario ingresar el valor inicial. En caso de no tener uno, el programa hará el valor inicial la media del intervalo de estudio.
    if (isnan(xo))%verificamos la variable xo está vacía.
        if(isempty(intervalo))%Ahora comprobamos si la variable intervalo que pedimos en el while pasado está vacío.
            %{
            La teoría del método de newton-raphson dice que si no se tiene
            un valor Xo este deberá ser la media del intervalo, por eso si
            el intervalo está vacío y Xo también, pedimos un Xo
            obligatorio.
            %}
            fprintf('Debes ingresar un Xo de manera obligatoria ya que no posees intervalo (Xo debe ser un numero).\n');
        else
            %Si xo está vacío pero intervalo no el Xo será igual a la media del intervalo.
            xo = (intervalo_a + intervalo_b) /2; 
            break;
        end
    else
        if (isnumeric(xo))%Si Xo no está vacío y es numerico, procederemos a salir del while.
            break;   
        end
    end
    
end

%{
Creamos un nuevo ciclo while que se ejecutará de forma indefinida hasta que
se cumpla unas condiciones.

La condición será que el usuario ingrese el numero de decimales con los que
se trabajará. Este numero debe ser un numero entero mayor o igual a cero.
%}
while (true)
    decimales = str2double(input ('Ingrese el numero de decimales con los que se trabajará: ','s')); %capturamos el valor.
    if(isnumeric(decimales) & decimales >=0) %comprobamos la variable decimales es un numero y si el numero es mayor a cero.
        if (mod(decimales,1) == 0)%Comprobamos si la variable decimales es un numero entero. Si lo es salimos del while.
            break;
        else
            fprintf('Debes ingresar un numero entero de 0 en adelante. Intenta de nuevo.\n');  %Si no es un numero entero, imprimimos un mensaje.  
        end
    else
        fprintf('Debes ingresar un numero entero de 0 en adelante. Intenta de nuevo.\n');%Si no es un numero, imprimimos un mensaje.
    end    
end

%{
Ahora que ya tenemos los datos necesarios recogidos y guardados en variables,
procedemos a aplicar el método newtown-raphson
%}

syms x %Esto hace que la letra X en la función ingresada no sea tratada como una constante sino como una variable.
f = inline(funcion); %convertimos la función obtenida en forma de caracter de texto a una función matemática simbólica con respecto a X.
derivada = inline(diff(funcion, x)); % Sacamos la derivada de la función con respecto a X y con el inline hacemos que el resultado sea una función matemática simbólica.
i = 0; %declaramos un contador iniciado en 0.
fprintf('f''(x) = %s', char(sym(diff(funcion, x)))); %imprimos en pantalla el f'(x). La función sym hace que se pueda ver la función sin modificar, y la función char hace que la función sea convertido a texto para poder imprimir.

%{

Creamos otro ciclo while, al igual que los pasados solo se detendrá si se
cumple una condición.

Esa condición es que o que se encuentre una raiz, xo = o
O que el valor de xo se repita.

%}

while(true)
    if(~isempty(intervalo))%verificamos de nuevo si intervalo está vacío
        if(intervalo_a > xo | intervalo_b > xo)%si no está vacío, comprobamos que el intervalo no sea mayor que Xo, si lo es quiere decir que no hay raiz. Por lo tanto el procedimiento se detendrá.
            fprintf('\nXo no puede ser mayor que el intervalo. Es posible que no haya raiz en ese intervalo o con el Xo especificado.\n');
            break;
        end
    end
    xo_viejo = str2double(sprintf('%.*f',decimales,xo)); %para poder hacer comprobaciones, guardamos el valor de xo en una variable llamada xo_viejo.
    xo = str2double(sprintf('%.*f',decimales,xo_viejo -( f(xo_viejo)/derivada(xo_viejo))));%hacemos la iteración para encontrar el nuevo Xo. La función básicamente lo que hace es tomar el valor de ese Xo, y ponerlo a los decimales que se nos piden.
    if (i > 0) %para no volver a imprimir Xo, hacemos que si i = 0 no imprima nada
        fprintf('\n| Iteración: %i | x%i = %.*f|', i,i,decimales, xo_viejo);%imprimimos la iteración.
    end
    i = i + 1;%i es el numero de iteraciones, así como el contador de los Xo, por eso le sumamamos una.
    if (xo_viejo == xo | xo == 0 | isnan(xo))%Comprobamos si el xo_viejo es igual al xo nuevo, si lo es, imprimimos y salimos del while.
        if (isnan(xo))
            xo = 0;
        end
        fprintf('\n| Iteración: %i | x%i = %.*f|\n', i,i,decimales, xo);
        break
    end

end

%{
Comenzamos la gráfica.
%}
fprintf('Graficando, por favor espere.');

%con la función ezplot graficamos la función.
ezplot(funcion,[-10,10,-10,10])%Ya que los resultados finales son valores bajos, se ha tomado los puntos -10,10 en cada eje para graficar.
grid on %Lanzamos el gráfico en la pantalla.