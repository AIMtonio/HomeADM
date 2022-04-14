-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SPEITRANSFERENCIASLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `SPEITRANSFERENCIASLIS`;

DELIMITER $$
CREATE PROCEDURE `SPEITRANSFERENCIASLIS`(
	-- SP listas de transferencias SPEI para clientes internos.
	Par_SpeiTransID		BIGINT(20),
    Par_Estatus	        CHAR(1),
	Par_NumLis			TINYINT UNSIGNED,

    Par_EmpresaID		INT,					-- Parámetro de auditoría ID de la empresa.
	Aud_Usuario			INT,					-- Parámetro de auditoría ID del usuario.
	Aud_FechaActual		DATETIME,				-- Parámetro de auditoría fecha actual.
	Aud_DireccionIP		VARCHAR(20),			-- Parámetro de auditoría direccion IP.
	Aud_ProgramaID		VARCHAR(50),			-- Parámetro de auditoría programa.
	Aud_Sucursal		INT,					-- Parámetro de auditoría ID de la sucursal.
	Aud_NumTransaccion	BIGINT					-- Parámetro de auditoría numero de transaccion.
)

TerminaStore: BEGIN

	-- Declaración de variables.

	-- Declaración de constantes.
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT;
	DECLARE Estatus_Reg         CHAR(1);
	DECLARE	Lis_Principal 		INT;

	-- Asignación de constantes.
	SET	Cadena_Vacia			:= '';
	SET	Fecha_Vacia				:= '1900-01-01';
	SET	Entero_Cero				:= 0;
	SET	Estatus_Reg				:= 'P';
	SET	Lis_Principal			:= 1;


	IF (Par_NumLis = Lis_Principal) THEN

		SELECT	ST.SpeiTransID,					ST.ClabeCli,						ST.NombreCli,					ST.Monto,							CA.CuentaAhoID,
				CL.ClienteID,					INS.Descripcion AS Banco,			SC.NombreSucurs,				CLR.NombreCompleto AS NombreRem,	CLR.RazonSocial AS RazonSocialRem,
				CLR.ClienteID AS clienteIDRem,	TPR.Descripcion AS TipoCuentaRem, 	CTR.CuentaAhoID AS CuentaRem
		FROM SPEITRANSFERENCIAS ST
		INNER JOIN REMESASWS RW ON RW.RemesaFolioID = ST.Referencia
		INNER JOIN CUENTASAHO CA ON CA.Clabe = ST.ClabeCli
		INNER JOIN CLIENTES CL ON CL.ClienteID = CA.ClienteID
		INNER JOIN SUCURSALES SC ON SC.SucursalID = CL.SucursalOrigen
		INNER JOIN INSTITUCIONESSPEI INS ON INS.InstitucionID = RW.InstitucionID
		INNER JOIN CUENTASAHO CTR ON CTR.Clabe = RW.CuentaClabeRemesa
		INNER JOIN CLIENTES CLR ON CLR.ClienteID = CTR.ClienteID
		INNER JOIN TIPOSCUENTAS TPR ON TPR.TipoCuentaID = CTR.TipoCuentaID
		WHERE ST.Estatus = Estatus_Reg;
	END IF;

END TerminaStore$$