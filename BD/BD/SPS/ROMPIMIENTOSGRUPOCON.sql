-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ROMPIMIENTOSGRUPOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `ROMPIMIENTOSGRUPOCON`;

DELIMITER $$
CREATE PROCEDURE `ROMPIMIENTOSGRUPOCON`(
	-- Store Procedure de Consulta para obtener los datos del Rompimiento de Grupos.
	-- Modulo WS
	Par_GrupoID			INT(11),		-- Numero de Grupo
	Par_NumConsulta		TINYINT UNSIGNED,	-- Numero de Consulta

	Aud_EmpresaID		INT(11),		-- Parámetro de auditoria ID de la Empresa
	Aud_Usuario			INT(11),		-- Parámetro de auditoria ID del usuario
	Aud_FechaActual		DATETIME,		-- Parámetro de auditoria Fecha actual
	Aud_DireccionIP		VARCHAR(15),	-- Parámetro de auditoria Direcciion IP
	Aud_ProgramaID		VARCHAR(50),	-- Parámetro de auditoria Programa
	Aud_Sucursal		INT(11),		-- Parámetro de auditoria ID de la sucursal
	Aud_NumTransaccion	BIGINT(20)		-- Parámetro de auditoria Número de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE Decimal_Cero	DECIMAL(14,2);	-- Constante Decimal Cero
	DECLARE Fecha_Vacia		DATE;			-- Constante Fecha Vacia
	DECLARE Entero_Cero		INT(11);		-- Constante Entero Cero
	DECLARE Cadena_Vacia	CHAR(1);		-- Constante Cadena Vacia
	DECLARE Est_Vencido		CHAR(1);		-- Estatus Credito Vencido

	DECLARE Est_Vigente		CHAR(1);		-- Estatus Credito Vigente
	DECLARE Est_Activo		CHAR(1);		-- Estatus Integrante Activo
	DECLARE Con_ExibileGrupal TINYINT UNSIGNED;	-- Numero de Consulta 2

	-- Asignacion de Constantes
	SET	Decimal_Cero		:= 0.00;
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET	Cadena_Vacia		:= '';
	SET Est_Vencido			:= 'B';

	SET Est_Vigente			:= 'V';
	SET Est_Activo 			:= 'A';
	SET	Con_ExibileGrupal 	:= 2;

	-- Consulta Principal
	IF( Par_NumConsulta = Con_ExibileGrupal ) THEN

		-- Exigible Grupal
		SELECT SUM(IFNULL(FUNCIONTOTDEUDACRE(Cre.CreditoID), Decimal_Cero)) AS ExigibleGrupal
		FROM INTEGRAGRUPOSCRE Ing,
			 SOLICITUDCREDITO Sol,
			 CREDITOS Cre
		WHERE Ing.GrupoID = Par_GrupoID
		  AND Ing.SolicitudCreditoID = Sol.SolicitudCreditoID
		  AND Sol.CreditoID = Cre.CreditoID
		  AND Ing.Estatus = Est_Activo
		  AND (Cre.Estatus = Est_Vigente OR Cre.Estatus = Est_Vencido);

	END IF;

END TerminaStore$$