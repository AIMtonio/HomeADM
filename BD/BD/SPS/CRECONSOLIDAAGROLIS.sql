-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRECONSOLIDAAGROLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRECONSOLIDAAGROLIS`;

DELIMITER $$
CREATE PROCEDURE `CRECONSOLIDAAGROLIS`(
-- =========================================================================
-- ----------SP PARA DAR LISTA LOS CREDITOS CONSOLIDADOS-----------
-- =========================================================================
	Par_CreditoID			VARCHAR(250),	    -- Credito ID
	Par_ClienteID 			INT(11),		    -- Numero del Cliente
	Par_FolioConsolidaID    BIGINT(12),            -- ID de Folio de Consolidacion
	Par_Transaccion			BIGINT(20),     	-- Numero de Transaccion de la tabla en sesion
	Par_NumLis				TINYINT UNSIGNED,   -- Numero de Lista

	Par_EmpresaID			INT(11),		    -- Parametro de Auditoria Numero de Empresa
	Aud_Usuario				INT(11),		    -- Parametro de Auditoria Usuario
	Aud_FechaActual			DATETIME,		    -- Parametro de Auditoria Fecha
	Aud_DireccionIP			VARCHAR(15),	    -- Parametro de Auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	    -- Parametro de Auditoria Programa ID
	Aud_Sucursal			INT(12),		    -- Parametro de Auditoria Sucursal
	Aud_NumTransaccion		BIGINT(20)		    -- Parametro de Auditoria Numero Transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia			CHAR(1);
	DECLARE	Fecha_Vacia				DATE;
	DECLARE	Entero_Cero				INT;
	DECLARE Decimal_Cero			DECIMAL(12,2);
	DECLARE	Lis_Principal 			INT(11);
	DECLARE Lis_CredGrid            INT(11);
	DECLARE Lis_CredDetalle         INT(11);
	DECLARE	Est_Vigente				CHAR(1);
	DECLARE	Est_Vencido				CHAR(1);
	DECLARE Var_SinGarantia         INT(11);
	DECLARE Var_GarFega             INT(11);
	DECLARE Var_GarFonaga           INT(11);
	DECLARE Var_Ambas               INT(11);
	DECLARE StringSI                CHAR(1);
	DECLARE StringNO                CHAR(1);
	DECLARE Rec_Propios             CHAR(1);
	DECLARE Int_Fondeo              CHAR(1);
	DECLARE Est_Inactiva              CHAR(1);


	-- Asignacion de Constantes
	SET Cadena_Vacia			:='';
	SET Fecha_Vacia 			:='1900-01-01';
	SET Entero_Cero				:= 0;
	SET Decimal_Cero			:= 0.0;
	SET Lis_Principal 			:= 1;
	SET Lis_CredGrid 			:= 2;
	SET Lis_CredDetalle         := 3;
	SET Est_Vigente 			:= 'V';
	SET Est_Vencido 			:= 'B';
	SET Var_SinGarantia         := 0;
	SET Var_GarFega             := 1;
	SET Var_GarFonaga           := 2;
	SET Var_Ambas               := 3;
	SET StringSI                := 'S';
	SET StringNO                := 'N';
	SET Rec_Propios             := 'P';             -- Tipo de Fondeo FIRA Recursos Propios
	SET Int_Fondeo              := 'F';             -- Tipo de Fonde FIRA Institucion de Fondeo
	SET Est_Inactiva            := 'I';             -- Estatus Inactivo

	-- Inicializacion de Variables

	IF(Par_NumLis = Lis_Principal) THEN
		SELECT Cre.CreditoID AS CreditoID,  Pro.Descripcion AS ProductoCreditoID,
			CASE Gar.TipoGarantiaID
				WHEN Var_SinGarantia THEN 'NINGUNA'
				WHEN Var_GarFega    THEN 'FEGA'
				WHEN Var_GarFonaga  THEN 'FONAGA'
				WHEN Var_Ambas      THEN 'AMBAS'
				ELSE 'NINGUNA' END AS TipoGarantia,
			CASE Cre.Estatus
				WHEN Est_Vigente THEN 'VIGENTE'
				WHEN Est_Vencido    THEN 'VENCIDO'
				ELSE 'VIGENTE' END AS Estatus
			FROM CREDITOS Cre
				INNER JOIN PRODUCTOSCREDITO Pro ON Cre.ProductoCreditoID = Pro.ProducCreditoID
				INNER JOIN CATTIPOGARANTIAFIRA Gar ON Cre.TipoGarantiaFIRAID = Gar.TipoGarantiaID
			WHERE Cre.CreditoID LIKE CONCAT("%", Par_CreditoID, "%")
				AND Cre.EsAgropecuario = StringSI
				AND Cre.Estatus IN (Est_Vigente, Est_Vencido)
				AND Cre.ClienteID = Par_ClienteID
			LIMIT 0, 15;
	END IF;

	IF(Par_NumLis = Lis_CredGrid)THEN

		SELECT Con.FolioConsolida AS FolioConsolidaID, Con.DetGridID AS DetalleFolioConsolidaID, Con.SolicitudCreditoID AS SolicitudCreditoID,
			Cre.CreditoID AS CreditoID,  Pro.Descripcion AS ProductoCreditoID,  FORMAT(Cre.MontoCredito, 2) AS MontoCredito,
			CASE Cre.TipoFondeo
				WHEN Rec_Propios THEN 'R. PROPIOS'
				WHEN Int_Fondeo THEN 'FIRA'
					ELSE 'R. PROPIOS' END AS FuenteFondeo,
			CASE Cre.Estatus
				WHEN Est_Vigente THEN 'VIGENTE'
				WHEN Est_Vencido    THEN 'VENCIDO'
					ELSE 'VIGENTE' END AS Estatus,
			CASE WHEN Gar.TipoGarantiaID > Entero_Cero THEN StringSI
					ELSE StringNO END AS GarantiaFIRA,
			CASE WHEN Cre.AporteCliente > Entero_Cero THEN StringSI
					ELSE StringNO END AS GarantiaLiq,
		   	FORMAT((Con.MontoCredito + Con.MontoProyeccion), 2) AS SaldoActual, IFNULL(Sol.Estatus, Est_Inactiva) AS EstatusSolicitud
			FROM CREDCONSOLIDAAGROGRID Con
				INNER JOIN CREDITOS Cre ON Con.CreditoID = Cre.CreditoID
				INNER JOIN PRODUCTOSCREDITO Pro ON Cre.ProductoCreditoID = Pro.ProducCreditoID
				INNER JOIN CATTIPOGARANTIAFIRA Gar ON Cre.TipoGarantiaFIRAID = Gar.TipoGarantiaID
				LEFT OUTER JOIN SOLICITUDCREDITO Sol ON Con.SolicitudCreditoID = Sol.SolicitudCreditoID
				WHERE Con.FolioConsolida = Par_FolioConsolidaID
				  AND Con.Transaccion = Par_Transaccion;
	END IF;

	-- lista para creditos misma de arriba pero apuntada a la Real
	IF(Par_NumLis = Lis_CredDetalle)THEN

		SELECT Con.FolioConsolida AS FolioConsolidaID, Con.DetConsolidaID AS DetalleFolioConsolidaID, Con.SolicitudCreditoID AS SolicitudCreditoID,
			Cre.CreditoID AS CreditoID,  Pro.Descripcion AS ProductoCreditoID,   FORMAT(Cre.MontoCredito, 2) AS MontoCredito,
			CASE Cre.TipoFondeo
				WHEN Rec_Propios THEN 'R. PROPIOS'
				WHEN Int_Fondeo THEN 'FIRA'
					ELSE 'R. PROPIOS' END AS FuenteFondeo,
			CASE Cre.Estatus
				WHEN Est_Vigente THEN 'VIGENTE'
				WHEN Est_Vencido    THEN 'VENCIDO'
					ELSE 'VIGENTE' END AS Estatus,
			CASE WHEN Gar.TipoGarantiaID > Entero_Cero THEN StringSI
					ELSE StringNO END AS GarantiaFIRA,
			CASE WHEN Cre.AporteCliente > Entero_Cero THEN StringSI
					ELSE StringNO END AS GarantiaLiq,
			FORMAT((Con.MontoCredito + Con.MontoProyeccion), 2) AS SaldoActual, Cadena_Vacia AS EstatusSolicitud
			FROM CRECONSOLIDAAGRODET Con
				INNER JOIN CREDITOS Cre ON Con.CreditoID = Cre.CreditoID
				INNER JOIN PRODUCTOSCREDITO Pro ON Cre.ProductoCreditoID = Pro.ProducCreditoID
				INNER JOIN CATTIPOGARANTIAFIRA Gar ON Cre.TipoGarantiaFIRAID = Gar.TipoGarantiaID
			WHERE Con.FolioConsolida = Par_FolioConsolidaID;
	END IF;

END TerminaStore$$