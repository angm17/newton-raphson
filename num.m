%{
Programa para calcular m�todo de newton-raphson.
Alumno: * Miguel Angel Angarita.
Programa usado: MatLab R2015a

Explicaci�n de algunas funciones las cuales se repiten muchas veces a lo
largo del c�digo, para no explicar una y otra vez para qu� sirven, se har� una sola vez:

* isempty: eval�a si una variable de texto est� vac�a.
* isnan: eval�a si una variable numerica est� vac�a.
* fprintf: imprime un valor formateado.
* str2double: transforma una variable tipo texto a una variable numerica tipo
double.
* isnumeric: verifica si una variable es numerica.
* break: Rompe un ciclo, en este caso se us� con el ciclo while.
* while(condicion): ejecuta un ciclo mientras se cumpla la condici�n dada. Si
la condici�n es "true", se ejecutar� para siempre a menos que el usuario
salga de �l haciendo un break.

* if(condici�n): Evalua si se cumple una condici�n. Si lo hace se ejecuta
un trozo de c�digo.
* else: Si esa condici�n no se cumple se ejecuta otro trozo de c�digo diferente.

%}
clear, clc %Limpia la consola y la memoria.
fprintf('C�lculo por m�todo Newton-Raphson.\n\n');%Imprimimos en pantalla el mensaje de t�tulo.

%{
Comenzando creando un ciclo while, que se repetir� infinitamente hasta que
se cumpla una condici�n.

Esa condici�n ser� que el usuario ingrese la funci�n a evaluar.

%}

while (true) %Comienza el ciclo while.
    funcion = input('Introduzca la funci�n f(x)=','s'); %Pedimos al usuario ingresar la funci�n con la que desea trabajar.
    if (isempty(funcion))%Comprobamos no ingreso nada.
        fprintf('Debes ingresar una funci�n.\n'); %Si no ingres� y la variable funcion est� vacia (isempty), imprimimos un mensaje que diga tal.
    else
        break; %Si ingres� algo, hacemos que el ciclo while se "rompa" y nos deje continuar.
    end
    
end%Termina el ciclo while.
%{
Creamos otro while que se ejecutar� indefinidamente hasta que se cumpla una
condici�n.

Esa condici�n ser� que si el usuario introduce un intervalo, este tenga que
cumplir el formato A-B.
%}
while (true)
    intervalo = input ('Ingrese el intervalo en el formato A-B en caso de tenerlo: ','s'); %pedimos al usuario insertar el intervalo de estudio, usando un gui�n como separador entre ellos.
    if (~isempty(intervalo)) %Si la variable intervalo est� vac�a:
        %{
        Preparamos el regex (expresi�n regular.)
        Este regex est� programado para que el usuario solo pueda insertar
        intervalos que cumplan con el formato A-B. Donde A y B son numeros
        obligatoriamente, puede haber espacios indefinidos entre ellos, ejemplo: A- B,
        A - B. Y solo un gui�n entre ellos.
%}
        regex = '^(\d+(?:\.\d+)?) *\-{1} *(\d+(?:\.\d+)?)$';
        if (regexp(intervalo, regex)) %procedemos a comprobar la variable intervalo con el regex usando la funci�n regexp de matlab
            intervalo = strsplit(intervalo, '-'); %usamos la funci�n strsplit para cortar el intervalo en el gui�n, lo cual nos devolver� un arreglo que m�s adelante asignaremos.
            intervalo_a = intervalo{1};%creamos una variable que guardar� el indice cero del arreglo intervalo.
            intervalo_b = intervalo{2};%al igual que arriba, creamos una variable que guarde el indice uno del arreglo intervalo.      
            break;
        else
            fprintf('El intevalo debe ser en formato A-B, ejemplo: 0-4.\n');%Si en la evaluaci�n del regex no se encontr� coincidencia, le indicamos al usuario un mensaje.
        end
    else
        break; %Ya que el uso de un intervalo no es obligado, si el usuario no ha ingresado uno, hacemos que el while se "rompa" y se siga ejecutando la otra parte del c�digo.
    end
end

%{
Creamos un nuevo ciclo while que se ejecutar� de forma indefinida hasta que
se cumpla unas condiciones.

Esas condiciones son: Que el usuario ingrese un valor para Xo. Que ese
valor sea un numero.
%}
while(true)
    xo = str2double(input('Ingrese el valor de Xo en caso de tenerlo, de lo contrario deje en blanco: Xo=','s')); %Pedimos al usuario ingresar el valor inicial. En caso de no tener uno, el programa har� el valor inicial la media del intervalo de estudio.
    if (isnan(xo))%verificamos la variable xo est� vac�a.
        if(isempty(intervalo))%Ahora comprobamos si la variable intervalo que pedimos en el while pasado est� vac�o.
            %{
            La teor�a del m�todo de newton-raphson dice que si no se tiene
            un valor Xo este deber� ser la media del intervalo, por eso si
            el intervalo est� vac�o y Xo tambi�n, pedimos un Xo
            obligatorio.
            %}
            fprintf('Debes ingresar un Xo de manera obligatoria ya que no posees intervalo (Xo debe ser un numero).\n');
        else
            %Si xo est� vac�o pero intervalo no el Xo ser� igual a la media del intervalo.
            xo = (intervalo_a + intervalo_b) /2; 
            break;
        end
    else
        if (isnumeric(xo))%Si Xo no est� vac�o y es numerico, procederemos a salir del while.
            break;   
        end
    end
    
end

%{
Creamos un nuevo ciclo while que se ejecutar� de forma indefinida hasta que
se cumpla unas condiciones.

La condici�n ser� que el usuario ingrese el numero de decimales con los que
se trabajar�. Este numero debe ser un numero entero mayor o igual a cero.
%}
while (true)
    decimales = str2double(input ('Ingrese el numero de decimales con los que se trabajar�: ','s')); %capturamos el valor.
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
procedemos a aplicar el m�todo newtown-raphson
%}

syms x %Esto hace que la letra X en la funci�n ingresada no sea tratada como una constante sino como una variable.
f = inline(funcion); %convertimos la funci�n obtenida en forma de caracter de texto a una funci�n matem�tica simb�lica con respecto a X.
derivada = inline(diff(funcion, x)); % Sacamos la derivada de la funci�n con respecto a X y con el inline hacemos que el resultado sea una funci�n matem�tica simb�lica.
i = 0; %declaramos un contador iniciado en 0.
fprintf('f''(x) = %s', char(sym(diff(funcion, x)))); %imprimos en pantalla el f'(x). La funci�n sym hace que se pueda ver la funci�n sin modificar, y la funci�n char hace que la funci�n sea convertido a texto para poder imprimir.

%{

Creamos otro ciclo while, al igual que los pasados solo se detendr� si se
cumple una condici�n.

Esa condici�n es que o que se encuentre una raiz, xo = o
O que el valor de xo se repita.

%}

while(true)
    if(~isempty(intervalo))%verificamos de nuevo si intervalo est� vac�o
        if(intervalo_a > xo | intervalo_b > xo)%si no est� vac�o, comprobamos que el intervalo no sea mayor que Xo, si lo es quiere decir que no hay raiz. Por lo tanto el procedimiento se detendr�.
            fprintf('\nXo no puede ser mayor que el intervalo. Es posible que no haya raiz en ese intervalo o con el Xo especificado.\n');
            break;
        end
    end
    xo_viejo = str2double(sprintf('%.*f',decimales,xo)); %para poder hacer comprobaciones, guardamos el valor de xo en una variable llamada xo_viejo.
    xo = str2double(sprintf('%.*f',decimales,xo_viejo -( f(xo_viejo)/derivada(xo_viejo))));%hacemos la iteraci�n para encontrar el nuevo Xo. La funci�n b�sicamente lo que hace es tomar el valor de ese Xo, y ponerlo a los decimales que se nos piden.
    if (i > 0) %para no volver a imprimir Xo, hacemos que si i = 0 no imprima nada
        fprintf('\n| Iteraci�n: %i | x%i = %.*f|', i,i,decimales, xo_viejo);%imprimimos la iteraci�n.
    end
    i = i + 1;%i es el numero de iteraciones, as� como el contador de los Xo, por eso le sumamamos una.
    if (xo_viejo == xo | xo == 0 | isnan(xo))%Comprobamos si el xo_viejo es igual al xo nuevo, si lo es, imprimimos y salimos del while.
        if (isnan(xo))
            xo = 0;
        end
        fprintf('\n| Iteraci�n: %i | x%i = %.*f|\n', i,i,decimales, xo);
        break
    end

end

%{
Comenzamos la gr�fica.
%}
fprintf('Graficando, por favor espere.');

%con la funci�n ezplot graficamos la funci�n.
ezplot(funcion,[-10,10,-10,10])%Ya que los resultados finales son valores bajos, se ha tomado los puntos -10,10 en cada eje para graficar.
grid on %Lanzamos el gr�fico en la pantalla.