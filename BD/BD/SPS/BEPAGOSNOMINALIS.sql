-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BEPAGOSNOMINALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `BEPAGOSNOMINALIS`;

DELIMITER $$
CREATE PROCEDURE `BEPAGOSNOMINALIS`(
	-- Store Procedure para listar la aplicacion de pagos de credito via Nomina por folio de carga
	-- Modulo: Credito Nomina --> Procesos --> Aplicacion Pagos Credito Nomina
	Par_FolioNominaID		INT(11),	-- Numero de Folio de Nomina
	Par_FolioCargaID		INT(11),	-- Numero de Folio de Carga
	Par_EmpresaNominaID		INT(11),	-- Numero de Empresa de Nomina
	Par_TipoLis				INT(11),	-- Tipo de Lista

	Par_EmpresaID			INT(11),	-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),	-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,	-- Parametro de auditoria Feha actual
	Aud_DireccionIP			VARCHAR(15),-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),	-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)	-- Parametro de auditoria Numero de la transaccion
)
TerminaStore:BEGIN

	-- Declaracion de Listas
	DECLARE Lis_Principal		INT(11);-- Lista Principal

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia		CHAR(1);-- Constante Cadena Vacia
	DECLARE Est_PorAplicar		CHAR(1);-- Constante Estatus por Aplicar
	DECLARE Con_NO				CHAR(1);-- Constante NO
	DECLARE Entero_Cero			INT(11);-- Constante Entero Cero
	DECLARE Entero_Uno			INT(11);-- Constante Entero Uno
	DECLARE	Fecha_Vacia			DATE;	-- Constante Fecha Vacia

	-- Declaracion de Listas
	SET Lis_Principal			:= 1 ;

	-- Declaracion de Constantes
	SET Cadena_Vacia			:= '';
	SET Est_PorAplicar			:= 'P';
	SET Con_NO					:= 'N';
	SET Entero_Cero				:= 0;
	SET Entero_Uno				:= 1;
	SET	Fecha_Vacia				:= '1900-01-01';


	IF( Par_TipoLis = Lis_Principal ) THEN

		SET @Consecutivo := Entero_Cero;
		SELECT 	@Consecutivo:=(@Consecutivo+Entero_Uno) AS ConsecutivoID, Con_NO AS EsSeleccionado,
				Pag.FolioNominaID, Pag.FechaCarga, Pag.MontoPagos, Pag.ClienteID, Pag.CreditoID
		FROM BEPAGOSNOMINA Pag
		INNER JOIN INSTITNOMINA Ins ON Pag.EmpresaNominaID = Ins.InstitNominaID
		WHERE Pag.Estatus = Est_PorAplicar
		  AND Pag.EmpresaNominaID = Par_EmpresaNominaID
		  AND Pag.FolioCargaID = Par_FolioCargaID;

	END IF;

END TerminaStore$$