-- SP ESQUEMAQUINQUENIOSLIS

DELIMITER ;

DROP PROCEDURE IF EXISTS ESQUEMAQUINQUENIOSLIS;

DELIMITER $$

CREATE PROCEDURE `ESQUEMAQUINQUENIOSLIS`(
	Par_InstitNominaID		INT(11),			-- Numero de Institucion Nomina
	Par_ConvenioNominaID    BIGINT UNSIGNED,			-- Numero de Convenio Nomina
    
	Par_NumLis				TINYINT UNSIGNED,	-- Numero de Lista
    
    Par_EmpresaID       	INT(11),			-- Parametro de Auditoria ID de la Empresa
    Aud_Usuario         	INT(11),			-- Parametro de Auditoria ID del Usuario
    Aud_FechaActual     	DATETIME,			-- Parametro de Auditoria Fecha Actual
    Aud_DireccionIP     	VARCHAR(15),		-- Parametro de Auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),		-- Parametro de Auditoria Programa
    Aud_Sucursal        	INT(11),			-- Parametro de Auditoria ID de la Sucursal
    Aud_NumTransaccion  	BIGINT(20)  		-- Parametro de Auditoria Numero de la Transaccion
	)
TerminaStore: BEGIN
    
	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);	-- Constante Cadena Vacia
	DECLARE	Fecha_Vacia			DATE;		-- Constante Fecha Vacia
	DECLARE	Entero_Cero			INT;		-- Constante Entero Cero
	DECLARE Lis_EsqQuinequenios	INT(11);	-- Lista de Esquema de Quinquenios

	-- Asignacion de Constantes
	SET	Cadena_Vacia			:= '';				-- Constante Cadena Vacia
	SET	Fecha_Vacia				:= '1900-01-01';	-- Constante Fecha Vacia
	SET	Entero_Cero				:= 0;		-- Constante Entero Cero
	SET Lis_EsqQuinequenios		:= 1;		-- Lista de Esquemas de Quinquenios
    
	-- 1.- Lista de Esquema de Quinquenios
	IF(Par_NumLis = Lis_EsqQuinequenios) THEN
		SELECT SucursalID,	QuinquenioID,	PlazoID
        FROM ESQUEMAQUINQUENIOS 
		WHERE InstitNominaID = Par_InstitNominaID
		AND ConvenioNominaID = Par_ConvenioNominaID;
	END IF;

END TerminaStore$$