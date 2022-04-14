-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNFMTHISPAGCIR
DELIMITER ;
DROP FUNCTION IF EXISTS `FNFMTHISPAGCIR`;
DELIMITER $$

CREATE FUNCTION `FNFMTHISPAGCIR`(
-- FUNCION PARA FORMATEAR LA CADENA DE HISTORIAL DE PAGOS DE LA CONSULTA DE CIRCULO DE CREDITO
	Par_CadenaOriginal	VARCHAR (5000),
    Par_NumPagos		INT

) RETURNS varchar(7000) CHARSET latin1
    DETERMINISTIC
BEGIN
	-- Constantes
    DECLARE Espacio_Blanco	CHAR(1);
    DECLARE Entero_Cero		INT;
    DECLARE Entero_Uno		INT;
    DECLARE Cadena_Punto	CHAR(1);
    DECLARE Incremento		INT;
    DECLARE Punto			CHAR(1);

	DECLARE Cadena_Vacia	CHAR(1);
	DECLARE Var_CadRestante	VARCHAR(7000);
	DECLARE Var_LongCadRest INT;
    DECLARE Var_LongCadOrig INT;
    DECLARE Var_Respuesta	VARCHAR(7000) ;
    DECLARE Var_Ocurrencias	INT;
    DECLARE Var_Posicion	INT;
    DECLARE Var_CadPagos	VARCHAR(7000);
	
    -- Establecer variables y constantes
    SET Espacio_Blanco	:= ' ';
    SET Cadena_Punto	:= '.';
    SET Entero_Cero		:=	0;
    SET Entero_Uno		:=	1;
    SET Incremento		:=	2;
    SET Cadena_Vacia	:= '';
    SET Punto			:= '.';

CicloProceso:begin
	SET Par_NumPagos	:= IFNULL(Par_NumPagos, Entero_Cero);

    SET Var_CadRestante := (LEFT(Par_CadenaOriginal,(Par_NumPagos*2)));    
    SET Var_LongCadOrig	:= LENGTH(Var_CadRestante);
    SET Var_Respuesta	:= Cadena_Vacia;
    SET Var_Posicion	:= Entero_Uno;
    SET Var_CadPagos	:= Cadena_Vacia;

	WHILE Var_Posicion <= Var_LongCadOrig DO
		
        SET Var_Respuesta := CONCAT(Var_Respuesta,
									substr(Var_CadRestante,Var_Posicion,Incremento),
									case when (Var_Posicion+Incremento) >= Var_LongCadOrig THEN Cadena_Vacia ELSE Cadena_Punto END);
        
        SET Var_Posicion := Var_Posicion+Incremento;
    
    END WHILE;

	SET Var_CadPagos := Var_Respuesta;

end CicloProceso;

    RETURN (Var_CadPagos);
    
END$$ 
