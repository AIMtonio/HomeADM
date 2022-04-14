-- SP REMITENTESUSUARIOSERVLIS

DELIMITER ;

DROP PROCEDURE IF EXISTS `REMITENTESUSUARIOSERVLIS`;

DELIMITER $$

CREATE PROCEDURE `REMITENTESUSUARIOSERVLIS` (
-- ====================================================================
-- ----- STORE PARA LA LISTA DE REMITENTES DE USUARIO DE SERVICIO -----
-- ====================================================================
	Par_UsuarioServicioID	INT(11),			-- Numero de Usuario de Servicio
	Par_RemitenteID			BIGINT(12),			-- Numero de Remitente
	Par_NombreComp			VARCHAR(50),		-- Nombre del Remitente
	Par_NumLis				TINYINT UNSIGNED,	-- Numero de Lista

	Par_EmpresaID       	INT(11),			-- Parametro de Auditoria ID de la Empresa
    Aud_Usuario         	INT(11),			-- Parametro de Auditoria ID del Usuario
    Aud_FechaActual     	DATETIME,			-- Parametro de Auditoria Fecha Actual
    Aud_DireccionIP     	VARCHAR(15),		-- Parametro de Auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),		-- Parametro de Auditoria Programa
    Aud_Sucursal        	INT(11),			-- Parametro de Auditoria ID de la Sucursal
    Aud_NumTransaccion  	BIGINT(20)  		-- Parametro de Auditoria Numero de la Transaccion
		)
TerminaStore:BEGIN

    -- Declaracion de Variables

	-- Declaracion de Constantes
	DECLARE Entero_Cero    	INT(11);		-- Entero Cero
    DECLARE Decimal_Cero	DECIMAL(14,2);	-- Decimal Cero
	DECLARE Cadena_Vacia   	CHAR(1);		-- Cadena Vacia
	DECLARE	Fecha_Vacia		DATE;			-- Fecha Vacia
    DECLARE ConstanteSI		CHAR(1);		-- Constante: SI

	DECLARE Lis_Remitentes	INT(11);		-- Lista de Remitentes de Usuario de Servicio

	-- Asignacion de Constantes
	SET Entero_Cero			:= 0; 			-- Entero Cero
    SET Decimal_Cero        := 0.00;		-- Decimal Cero
	SET Cadena_Vacia		:= '';    		-- Cadena Vacia
	SET	Fecha_Vacia			:= '1900-01-01';	-- Fecha Vacia
    SET ConstanteSI			:= 'S';			-- Constante: SI

	SET Lis_Remitentes		:= 3;			-- Lista de Remitentes de Usuario de Servicio

    -- 1.- Lista de Remitentes de Usuario de Servicio
	IF(Par_NumLis = Lis_Remitentes)THEN
		SELECT  RemitenteID,NombreCompleto
        FROM REMITENTESUSUARIOSERV
        WHERE  UsuarioServicioID = Par_UsuarioServicioID
        AND NombreCompleto LIKE CONCAT("%", Par_NombreComp, "%")
		LIMIT 0,15;
	END IF;

END TerminaStore$$