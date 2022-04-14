-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BEPAGOSAPLINOMINALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `BEPAGOSAPLINOMINALIS`;
DELIMITER $$

CREATE PROCEDURE `BEPAGOSAPLINOMINALIS`(
-- =====================================================
-- ------- STORED DE LISTA DE FOLIOS DE NOMINA ---------
-- =====================================================
	Par_EmpresaNominaID		INT(11),                -- Empresa de Nomina ID 
    Par_FolioCargaID		INT(11),                -- Folio de Carga Nomina
	Par_TipoLis				INT(11),                -- Tipo de Lista

	Par_EmpresaID       	INT(11),                -- Parametros de Auditoria
    Aud_Usuario         	INT(11),                -- Parametros de Auditoria
    Aud_FechaActual     	DATETIME,               -- Parametros de Auditoria
    Aud_DireccionIP     	VARCHAR(15),            -- Parametros de Auditoria
    Aud_ProgramaID      	VARCHAR(50),            -- Parametros de Auditoria
    Aud_Sucursal        	INT(11),                -- Parametros de Auditoria
    Aud_NumTransaccion  	BIGINT(20)              -- Parametros de Auditoria
	)
TerminaStore:BEGIN
    -- Declaracion de Variables
    DECLARE FechaSis            DATE;               -- Fecha del Sistema
    -- Declaracion de Constantes
    DECLARE Lis_CredPagados	    INT;                -- Lista para Creditos Pagodos
    DECLARE Est_Aplicado		CHAR(1);            -- Estatus de Aplicado o Pagado
    DECLARE Cadena_Vacia   	 	CHAR(1);            -- Constante Cadena Vacia
    DECLARE	Fecha_Vacia			DATE;               -- Constante Fecha Vacia
    DECLARE Entero_Cero    		INT ;               -- Constante Entero Cero

    -- Seteo de Constantes
    SET Lis_CredPagados		    := 1 ;
    SET Est_Aplicado			:= 'A';
    SET Cadena_Vacia			:= '';
    SET	Fecha_Vacia				:= '1900-01-01';
    SET Entero_Cero				:= 0;


    IF(Par_TipoLis = Lis_CredPagados)THEN

        SELECT Pag.CreditoID,    Pag.ClienteID,     Pag.FechaAplicacion AS FechaPago,    Pag.MontoPagos AS MontoAplicado,
                Pro.Descripcion AS ProductoCredito
            FROM BEPAGOSNOMINA Pag
            INNER JOIN INSTITNOMINA Ins ON Pag.EmpresaNominaID=Ins.InstitNominaID
            INNER JOIN CREDITOS Cre ON Cre.CreditoID = Pag.CreditoID
            INNER JOIN PRODUCTOSCREDITO Pro ON Pro.ProducCreditoID  = Cre.ProductoCreditoID
            WHERE Pag.Estatus = Est_Aplicado
            AND  EmpresaNominaID= Par_EmpresaNominaID
            AND  Pag.FolioCargaID= Par_FolioCargaID;

    END IF;


END TerminaStore$$