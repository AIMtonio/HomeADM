-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPACTIVOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TMPACTIVOSLIS`;

DELIMITER $$
CREATE PROCEDURE `TMPACTIVOSLIS`(
	-- Store Procedure de Lista de Errores en la Carga Masiva de Activos
	-- Modulo: Activos --> Registro --> Carga Masiva
	Par_TransaccionID		BIGINT(20),		-- Numero de Transaccion
	Par_NumLista			TINYINT UNSIGNED,-- Numero de Lista

	Par_EmpresaID			INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria Fecha actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE Fecha_Vacia			DATE;			-- Constante Fecha vacia
	DECLARE Entero_Uno			INT(11);		-- Constante Entero Uno
	DECLARE Entero_Cero			INT(11);		-- Constante Entero cero
	DECLARE Cadena_Vacia		CHAR(1);		-- Constante cadena vacia
	DECLARE Con_SI				CHAR(1);		-- Constante SI

	DECLARE Con_NO				CHAR(1);		-- Constante NO
	DECLARE Decimal_Cero		DECIMAL(14,2);	-- Constante Decimal cero

	-- Declaracion de lista
	DECLARE Lis_Principal		TINYINT UNSIGNED;

	-- Asignacion de Constantes
	SET Fecha_Vacia				:= '1900-01-01';
	SET Entero_Cero				:= 0;
	SET Entero_Uno				:= 1;
	SET Cadena_Vacia			:= '';
	SET Con_SI					:= 'S';

	SET Con_NO					:= 'N';
	SET Decimal_Cero			:= 0.00;

	-- Asignacion de lista
	SET Lis_Principal			:= 1;

	IF( Par_NumLista = Lis_Principal ) THEN

		SELECT	RegistroID AS NumeroConsecutivo,				TransaccionID,		ConsecutivoCliente AS RegistroID,
				TipoActivoID,			Descripcion,			FechaAdquisicion,	NumFactura,					NumSerie,
				Moi,					DepreciadoAcumulado,	TotalDepreciar,		MesesUsos AS MesesUso,		PolizaFactura,
				CentroCostoID,			CuentaContable AS CtaContable,				CuentaContableRegistro AS CtaContableRegistro,
				PorDepFiscal,			DepFiscalSaldoInicio,	DepFiscalSaldoFin
		FROM TMPACTIVOS
		WHERE TransaccionID = Par_TransaccionID;

	END IF;

END TerminaStore$$