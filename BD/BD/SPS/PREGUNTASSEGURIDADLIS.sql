-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PREGUNTASSEGURIDADLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `PREGUNTASSEGURIDADLIS`;DELIMITER $$

CREATE PROCEDURE `PREGUNTASSEGURIDADLIS`(
	-- Lista de Verificacion de Preguntas
    Par_ClienteID			INT(11),			-- Numero de Cliente
	Par_NumLis				TINYINT UNSIGNED,	-- Numero de Lista

	Par_EmpresaID       	INT(11), 			-- Parametros de Auditoria
    Aud_Usuario         	INT(11),			-- Parametros de Auditoria
    Aud_FechaActual     	DATETIME,			-- Parametros de Auditoria
    Aud_DireccionIP     	VARCHAR(15),		-- Parametros de Auditoria
    Aud_ProgramaID      	VARCHAR(50),  		-- Parametros de Auditoria
    Aud_Sucursal        	INT(11),			-- Parametros de Auditoria
    Aud_NumTransaccion  	BIGINT(20)			-- Parametros de Auditoria
)
TerminaStore: BEGIN

    -- Declaracion de Variables
    DECLARE Var_NumPreguntas  INT(11);
    DECLARE Var_NumRegistro	  INT(11);

    -- Declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia     	DATETIME;
	DECLARE Entero_Cero     	INT(11);
    DECLARE	Lis_Combo   		CHAR(1);
    DECLARE	Lis_RegPreguntas   	CHAR(1);

    DECLARE	Lis_ModPreguntas   	CHAR(1);

	-- Asignacion de Constantes
	SET Cadena_Vacia    	:= '';				-- Cadena vacia
	SET Fecha_Vacia     	:= '1900-01-01';	-- Fecha vacia
	SET Entero_Cero     	:= 0;				-- Entero cero
    SET	Lis_Combo       	:= 1;				-- Lista Combo
    SET Lis_RegPreguntas	:= 6;				-- Lista para el registro de Preguntas

	SET Lis_ModPreguntas	:= 7;				-- Lista para la modificacion de Preguntas de Seguridad

	-- Lista Combo
	IF(Par_NumLis = Lis_Combo) THEN
	    SELECT PreguntaID, Descripcion
		FROM CATPREGUNTASSEG
		ORDER BY PreguntaID;
	END IF;

    -- Lista para el registro de Preguntas de Seguridad
    IF(Par_NumLis = Lis_RegPreguntas) THEN
		SET Var_NumPreguntas  := (SELECT NumeroPreguntas FROM PARAMETROSPDM LIMIT 1);

		SELECT Cat.PreguntaID,IFNULL(Pre.Respuestas,Cadena_Vacia) AS Respuestas
		FROM CATPREGUNTASSEG Cat
		INNER JOIN PARAMETROSPDM Par
		ON Cat.EmpresaID = Par.EmpresaID
		LEFT JOIN PREGUNTASSEGURIDAD Pre
		ON Pre.PreguntaID = Cat.PreguntaID
		AND Pre.ClienteID = Par_ClienteID
         LIMIT Var_NumPreguntas;

    END IF;

    -- Lista para el registro de Preguntas ya registradas
    IF(Par_NumLis = Lis_ModPreguntas) THEN
		SET Var_NumPreguntas  := (SELECT NumeroPreguntas FROM PARAMETROSPDM LIMIT 1);

		(SELECT Cat.PreguntaID,IFNULL(Pre.Respuestas,Cadena_Vacia) AS Respuestas
		FROM CATPREGUNTASSEG Cat
		INNER JOIN PARAMETROSPDM Par
		ON Cat.EmpresaID = Par.EmpresaID
		INNER JOIN PREGUNTASSEGURIDAD Pre
		ON Pre.PreguntaID = Cat.PreguntaID
		AND Pre.ClienteID = Par_ClienteID)
        UNION
        (SELECT Cat.PreguntaID,IFNULL(Pre.Respuestas,Cadena_Vacia) AS Respuestas
		FROM CATPREGUNTASSEG Cat
		INNER JOIN PARAMETROSPDM Par
		ON Cat.EmpresaID = Par.EmpresaID
		LEFT JOIN PREGUNTASSEGURIDAD Pre
		ON Pre.PreguntaID = Cat.PreguntaID
		AND Pre.ClienteID = Par_ClienteID)
        LIMIT Var_NumPreguntas;


    END IF;

END TerminaStore$$