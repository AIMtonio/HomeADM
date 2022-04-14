DELIMITER ;
DROP PROCEDURE IF EXISTS `BANCUENTASCARGOLIS`;
DELIMITER $$
CREATE PROCEDURE `BANCUENTASCARGOLIS`(
	-- SP de listas de cuentas cargo
	Par_ClienteID       INT(12),				-- Parametro de cliente ID
	Par_TamanioLista	INT(11),				-- parametro tamaniode la lista
	Par_PosicionInicial	INT(11),				-- Parametro posicion inicial de la lista
	Par_NumLis			INT(12),				-- Parametro de tipo de Lista

	Aud_EmpresaID		INT(11),				-- Parametro de auditoria
	Aud_Usuario			INT(11),				-- Parametro de auditoria
	Aud_FechaActual		DATETIME,				-- Parametro de auditoria
	Aud_DireccionIP		VARCHAR(15),			-- Parametro de auditoria
	Aud_ProgramaID		VARCHAR(50),			-- Parametro de auditoria
	Aud_Sucursal		INT(11),				-- Parametro de auditoria
	Aud_NumTransaccion	BIGINT(20)				-- Parametro de auditoria
)
TerminaStore: BEGIN

	-- DECLARACION DE CONSTANTES
    DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT(11);
	DECLARE Est_Activo		CHAR(1);
	DECLARE Lis_principal	INT(1);
	DECLARE Lis_combo		INT(1);
	DECLARE Tipo_Cuenta		CHAR(1);


	-- ASIGNACION DE CONSTANTES
	SET Est_Activo		:='A';  			-- Estatus Activo.
	SET Tipo_Cuenta		:= 'C';				-- Son tipos Cuentas
	SET	Cadena_Vacia	:= '';				-- Cadena Vacia
	SET	Fecha_Vacia		:= '1900-01-01';	-- Fecha Vacia
	SET	Entero_Cero		:= 0;				-- Entero en Cero
	SET	Lis_Principal	:= 1;				-- Lista Principal
	SET	Lis_combo		:= 2;				-- Lista para combos

	SET Par_TamanioLista		:=	IFNULL(Par_TamanioLista, Entero_Cero);
	SET Par_PosicionInicial		:=	IFNULL(Par_PosicionInicial, Entero_Cero);
	SET Par_ClienteID			:=	IFNULL(Par_ClienteID, Entero_Cero);

	-- Consulta Principal
	IF(Par_NumLis = Lis_Principal) THEN

		SELECT 	Aho.ClienteID, 	Aho.CuentaAhoID, 	Aho.Estatus,	 Tipo_Cuenta AS TipoCuenta, 	Aho.SaldoDispon,
				Aho.Etiqueta,  Aho.FechaApertura, 	tc.Descripcion,	 s.NombreSucurs
				FROM CUENTASAHO AS Aho
					INNER JOIN TIPOSCUENTAS tc 	ON Aho.TipoCuentaID 	= tc.TipoCuentaID
					INNER JOIN SUCURSALES   s 	 ON Aho.SucursalID   = s.SucursalID
				WHERE Aho.ClienteID = IF (Par_ClienteID > Entero_Cero, Par_ClienteID, Aho.ClienteID)
					AND Aho.Estatus = Est_Activo
				ORDER BY Aho.CuentaAhoID;


	END IF;

END TerminaStore$$
