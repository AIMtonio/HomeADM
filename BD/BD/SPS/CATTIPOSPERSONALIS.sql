-- SP CATTIPOSPERSONALIS

DELIMITER ;

DROP PROCEDURE IF EXISTS `CATTIPOSPERSONALIS`;

DELIMITER $$

CREATE PROCEDURE `CATTIPOSPERSONALIS` (
-- ==========================================================
-- -------- STORE PARA LA LISTA DE TIPOS DE PERSONA ---------
-- ==========================================================
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
	DECLARE Entero_Cero    		INT(11);		-- Entero Cero
    DECLARE Decimal_Cero		DECIMAL(14,2);	-- Decimal Cero
	DECLARE Cadena_Vacia   		CHAR(1);		-- Cadena Vacia
	DECLARE	Fecha_Vacia			DATE;			-- Fecha Vacia
    DECLARE ConstanteSI			CHAR(1);		-- Constante: SI

	DECLARE Lis_TiposPersona	INT(11);		-- Lista de Tipos de Persona

	-- Asignacion de Constantes
	SET Entero_Cero				:= 0; 			-- Entero Cero
    SET Decimal_Cero        	:= 0.00;		-- Decimal Cero
	SET Cadena_Vacia			:= '';    		-- Cadena Vacia
	SET	Fecha_Vacia				:= '1900-01-01';	-- Fecha Vacia
    SET ConstanteSI				:= 'S';			-- Constante: SI

	SET Lis_TiposPersona		:= 3;			-- Lista de Tipos de Persona

    -- 3.- Lista de Tipos de Persona
	IF(Par_NumLis = Lis_TiposPersona)THEN
		SELECT  TipoPersona,Descripcion
        FROM CATTIPOSPERSONA;
	END IF;

END TerminaStore$$