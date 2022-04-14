-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNLIMPIACARACTBUROCRED
DELIMITER ;
DROP FUNCTION IF EXISTS `FNLIMPIACARACTBUROCRED`;
DELIMITER $$

CREATE FUNCTION `FNLIMPIACARACTBUROCRED`(
	-- Funcion para limpiar los caracteres especiales en buro de credito
	Par_Texto 			VARCHAR(2000),	-- Texto a Limpiar
	Par_TipoLimpieza	CHAR(2)			-- Tipo de limpiado
) RETURNS varchar(2000) CHARSET latin1
    DETERMINISTIC
BEGIN

	-- Declaracion de Variable
	DECLARE Var_Longitud		INT(11);		-- Longitud del Texto
	DECLARE Var_Resultado 		VARCHAR(2000);	-- Resultado

	-- Declaracion de Constante
	DECLARE Cadena_Vacia		CHAR(1);		-- Constante de Cadena  Vacia
	DECLARE Entero_Cero			INT(11);		-- Constante de Entero Cero
	DECLARE Entero_Uno			INT(11);		-- Constante de Entero Uno
	DECLARE Entero_Dos			INT(11);		-- Constante de Entero Dos
	DECLARE Entero_Tres			INT(11);		-- Constante de Entero Tres
	DECLARE Entero_Cuatro		INT(11);		-- Constante de Entero Cuatro
	DECLARE Entero_Cinco		INT(11);		-- Constante de Entero Cinco
	DECLARE Entero_Seis			INT(11);		-- Constante de Entero Seis
	DECLARE Entero_Siete		INT(11);		-- Constante de Entero Siete
	DECLARE Entero_Ocho			INT(11);		-- Constante de Entero Ocho
	DECLARE Entero_Nueve		INT(11);		-- Constante de Entero Nueve

	DECLARE LetraEneMayu		CHAR(1);		-- Constante de la Letra Ene Mayuscula
	DECLARE LetraEneMinis		CHAR(1);		-- Constante de la Letra Ene Minuscula
	DECLARE LetraEnieMayu		CHAR(1);		-- Constante de la Letra Enie Mayuscula
	DECLARE LetraEnieMinis		CHAR(1);		-- Constante de la Letra Enie Minuscula


	DECLARE LimpiaAlfabetico	VARCHAR(2);		-- Limpiar Alfabeto
	DECLARE LimpiaAlfaNumerico	VARCHAR(2);		-- Limpiar Numeros
	DECLARE TextoMayusculas		VARCHAR(2);		-- Texto en Mayusculas
	DECLARE LimpiaLetras		VARCHAR(2);		-- Limpiar las letras y dejar solo numeros

	-- Asignacion de Constantes
	SET Cadena_Vacia			:= '';		-- Constante de Cadena  Vacia
	SET Entero_Cero				:= 0;		-- Constante de Entero Cero
	SET Entero_Uno				:= 1;		-- Constante de Entero Uno
	SET Entero_Dos				:= 2;		-- Constante de Entero Dos
	SET Entero_Tres				:= 3;		-- Constante de Entero Tres
	SET Entero_Cuatro			:= 4;		-- Constante de Entero Cuatro
	SET Entero_Cinco			:= 5;		-- Constante de Entero Cinco
	SET Entero_Seis				:= 6;		-- Constante de Entero Seis
	SET Entero_Siete			:= 7;		-- Constante de Entero Siete
	SET Entero_Ocho				:= 8;		-- Constante de Entero Ocho
	SET Entero_Nueve			:= 9;		-- Constante de Entero Nueve
	SET LetraEneMayu			:= 'N';		-- Constante de la Letra Ene Mayuscula
	SET LetraEneMinis			:= 'n';		-- Constante de la Letra Ene Minuscula
	SET LetraEnieMayu			:= 'Ñ';		-- Constante de la Letra Enie Mayuscula
	SET LetraEnieMinis			:= 'ñ';		-- Constante de la Letra Enie Minuscula
	SET LimpiaAlfabetico		:= 'A';		-- Limpiar Alfabeto
	SET LimpiaAlfaNumerico		:= 'AN';	-- Limpiar Numeros
	SET TextoMayusculas			:= 'MA';	-- Texto en Mayusculas
	SET LimpiaLetras			:= 'SN';	-- SOLO NUMEROS
    
	SET Par_Texto := FNLIMPIACARACTERESCRE(Par_Texto, TextoMayusculas);
	SET Par_TipoLimpieza := IFNULL(UPPER(Par_TipoLimpieza),Cadena_Vacia);

	IF(Par_TipoLimpieza=LimpiaAlfaNumerico OR Par_TipoLimpieza=LimpiaAlfabetico)THEN
		SET Par_Texto 		:= REPLACE(Par_Texto, LetraEnieMayu, LetraEneMayu);
		SET Par_Texto 		:= REPLACE(Par_Texto, LetraEnieMinis, LetraEneMinis);
	END IF;

	IF(Par_TipoLimpieza=LimpiaAlfabetico)THEN
		SET Par_Texto		:= REPLACE(Par_Texto, Entero_Cero, Cadena_Vacia);
		SET Par_Texto		:= REPLACE(Par_Texto, Entero_Uno, Cadena_Vacia);
		SET Par_Texto		:= REPLACE(Par_Texto, Entero_Dos, Cadena_Vacia);
		SET Par_Texto		:= REPLACE(Par_Texto, Entero_Tres, Cadena_Vacia);
		SET Par_Texto		:= REPLACE(Par_Texto, Entero_Cuatro, Cadena_Vacia);
		SET Par_Texto		:= REPLACE(Par_Texto, Entero_Cinco, Cadena_Vacia);
		SET Par_Texto		:= REPLACE(Par_Texto, Entero_Seis, Cadena_Vacia);
		SET Par_Texto		:= REPLACE(Par_Texto, Entero_Siete, Cadena_Vacia);
		SET Par_Texto		:= REPLACE(Par_Texto, Entero_Ocho, Cadena_Vacia);
		SET Par_Texto		:= REPLACE(Par_Texto, Entero_Nueve, Cadena_Vacia);
	END IF;
	
    IF(Par_TipoLimpieza=LimpiaLetras)THEN
		SET Par_Texto := FNLIMPIACARACTERESGEN(Par_Texto, "MA");
		SET Par_Texto	:= REPLACE(Par_Texto, "A", Cadena_Vacia);
		SET Par_Texto	:= REPLACE(Par_Texto, "B", Cadena_Vacia);
		SET Par_Texto	:= REPLACE(Par_Texto, "C", Cadena_Vacia);
		SET Par_Texto	:= REPLACE(Par_Texto, "D", Cadena_Vacia);
		SET Par_Texto	:= REPLACE(Par_Texto, "E", Cadena_Vacia);
		SET Par_Texto	:= REPLACE(Par_Texto, "F", Cadena_Vacia);
		SET Par_Texto	:= REPLACE(Par_Texto, "G", Cadena_Vacia);
		SET Par_Texto	:= REPLACE(Par_Texto, "H", Cadena_Vacia);
		SET Par_Texto	:= REPLACE(Par_Texto, "I", Cadena_Vacia);
		SET Par_Texto	:= REPLACE(Par_Texto, "J", Cadena_Vacia);
		SET Par_Texto	:= REPLACE(Par_Texto, "K", Cadena_Vacia);
		SET Par_Texto	:= REPLACE(Par_Texto, "L", Cadena_Vacia);
		SET Par_Texto	:= REPLACE(Par_Texto, "M", Cadena_Vacia);
		SET Par_Texto	:= REPLACE(Par_Texto, "N", Cadena_Vacia);
		SET Par_Texto	:= REPLACE(Par_Texto, "Ñ", Cadena_Vacia);
		SET Par_Texto	:= REPLACE(Par_Texto, "O", Cadena_Vacia);
		SET Par_Texto	:= REPLACE(Par_Texto, "P", Cadena_Vacia);
		SET Par_Texto	:= REPLACE(Par_Texto, "Q", Cadena_Vacia);
		SET Par_Texto	:= REPLACE(Par_Texto, "R", Cadena_Vacia);
		SET Par_Texto	:= REPLACE(Par_Texto, "S", Cadena_Vacia);
		SET Par_Texto	:= REPLACE(Par_Texto, "T", Cadena_Vacia);
		SET Par_Texto	:= REPLACE(Par_Texto, "U", Cadena_Vacia);
		SET Par_Texto	:= REPLACE(Par_Texto, "V", Cadena_Vacia);
		SET Par_Texto	:= REPLACE(Par_Texto, "W", Cadena_Vacia);
		SET Par_Texto	:= REPLACE(Par_Texto, "X", Cadena_Vacia);
		SET Par_Texto	:= REPLACE(Par_Texto, "Y", Cadena_Vacia);
		SET Par_Texto	:= REPLACE(Par_Texto, "Z", Cadena_Vacia);
        
        IF(Par_Texto = Cadena_Vacia)THEN
			SET Par_Texto:=0;
        END IF;
    END IF;
    
	SET Var_Resultado 	:= TRIM(UPPER(Par_Texto));

	RETURN Var_Resultado;

END$$