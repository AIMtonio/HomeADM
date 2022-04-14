-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FOLIOSNOMINALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `FOLIOSNOMINALIS`;
DELIMITER $$

CREATE PROCEDURE `FOLIOSNOMINALIS`(
-- =====================================================
-- ------- STORED DE LISTA DE FOLIOS DE NOMINA ---------
-- =====================================================
	Par_EmpresaNominaID		INT(20),	        -- Numero de la Institucion de Nomina
    Par_FolioCarga          VARCHAR(11),        -- Folio de Carga 
	Par_NumLis				TINYINT UNSIGNED,   -- Numero de lista

    Par_EmpresaID       	INT(11),		    -- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),		    -- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,		    -- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),	    -- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),	    -- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),		    -- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  	    -- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN
    -- DECLARACION DE VARIABLES
    DECLARE Var_FechaSis        DATE;
	-- DECLARACION DE CONSTANTES
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT(11);
	DECLARE	Lis_Principal 		INT(11);
    DECLARE Est_Procesado       CHAR(1);


	-- ASIGNACION DE CONSTANTES
	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET	Lis_Principal		:= 1;
    SET Est_Procesado       := 'P';

    SET Var_FechaSis := (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
	-- Lista 1 Principal
	IF(Par_NumLis = Lis_Principal) THEN

        SELECT	FolioCargaID
		FROM BECARGAPAGNOMINA
		WHERE  FolioCargaID LIKE CONCAT("%", Par_FolioCarga, "%")
            AND EmpresaNominaID = Par_EmpresaNominaID
            AND Estatus = Est_Procesado
            AND FechaApliPago = Var_FechaSis
		GROUP BY FolioCargaID
		LIMIT 0, 15;

	END IF;



END TerminaStore$$