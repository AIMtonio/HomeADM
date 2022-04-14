-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSCUENTALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOSCUENTALIS`;
DELIMITER $$

CREATE PROCEDURE `TIPOSCUENTALIS`(
	Par_Descripcion		VARCHAR(50),		-- Descripcion de la Cuenta
	Par_NumLis		 	TINYINT UNSIGNED,	-- Numero de Lista

	Par_EmpresaID		INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario			INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual		DATETIME,			-- Parametro de auditoria Feha actual
	Aud_DireccionIP		VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID		VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal		INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion	BIGINT(20)			-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_ClienteInst		INT(11);		-- Cliente Institucional

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia		CHAR(1);		-- Cadena Vacia
	DECLARE	Fecha_Vacia			DATE;			-- Fecha Vacia
	DECLARE	Entero_Cero			INT(11);		-- Entero Cero
	DECLARE	Lis_Principal		INT(11);		-- Lista principal
	DECLARE	Lis_Foranea			INT(11);		-- Lista foranea
	DECLARE	Lis_PorContrat		INT(11);		-- Lista Por Contrato
	DECLARE	Lis_DifBanc			INT(11);		-- Lista de cuenta no bancarias
	DECLARE	Lis_CombCueXTar		INT(11);		-- Lista para los tipos de cuenta segun la tarjeta
	DECLARE Lis_CtaCliente		INT(11);		-- Lista para los tipos de cuenta de los Clientes
	DECLARE Lis_CtaCapitalizan	INT(11);		-- Lista de cuenta bancarias
    DECLARE Lis_TipCtasActivos	INT(11);		-- Lista los tipos de cuentas activos
	DECLARE Lis_ComboTipCtasAct	INT(11);		-- Lista Combo de los tipos de cuentas activos
	DECLARE Lis_DifBancActivos	INT(11);		-- Lista Combo de los tipos de cuentas activos y que no son bancarias

	DECLARE	Con_SI				CHAR(1);		-- Constante SI
	DECLARE Estatus_Activo		CHAR(1);		-- Estatus Activo

	-- Asignacion de constantes
	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET	Lis_Principal		:= 1;
	SET	Lis_Foranea			:= 2;
	SET	Lis_PorContrat		:= 3;
	SET	Lis_DifBanc			:= 4;
	SET	Lis_CombCueXTar		:= 5;
	SET Lis_CtaCliente		:= 6;
	SET Lis_CtaCapitalizan	:= 7;
    SET Lis_TipCtasActivos	:= 8;
    SET Lis_ComboTipCtasAct	:= 9;
    SET Lis_DifBancActivos	:= 10;
	SET	Con_SI				:= 'S';
	SET Estatus_Activo		:= 'A';

	-- Lista Principal
	IF(Par_NumLis = Lis_Principal) THEN
		SELECT 	`TipoCuentaID`,	`Descripcion`
		FROM 	TIPOSCUENTAS
		WHERE `Descripcion` LIKE CONCAT("%", Par_Descripcion, "%")
		LIMIT 0, 15;
	END IF;

	-- Lista foranea
	IF(Par_NumLis = Lis_Foranea) THEN
		SELECT 	`TipoCuentaID`,	`Descripcion`
		FROM 	TIPOSCUENTAS;
	END IF;

	-- Lista por Contrato
	IF(Par_NumLis = Lis_PorContrat) THEN
		SELECT 	TipoCuentaID,		Descripcion,	ComApertura,	ComManejoCta,	ComAniversario,
				CobraBanEle,		CobraSpei,		ComFalsoCobro,	ComDispSeg,		SaldoMInReq
		FROM 		TIPOSCUENTAS
		WHERE TipoCuentaID=Par_TipoCtaID;
	END IF;

	-- muestra una lista de todas las cuentas que no son bancarias
	IF(Par_NumLis = Lis_DifBanc) THEN
		SELECT 	`TipoCuentaID`,	`Descripcion`
			FROM 	TIPOSCUENTAS
			WHERE Esbancaria <> Con_SI;
	END IF;

	-- Lista para los tipos de cuenta segun la tarjeta
	IF(Par_NumLis = Lis_CombCueXTar) THEN
		SELECT 	td.TipoCuentaID,	`Descripcion`
			FROM 	TIPOSCUENTATARDEB td, TIPOSCUENTAS tc
			WHERE	td.TipoCuentaID = tc.TipoCuentaID
			AND		TipoTarjetaDebID = Par_Descripcion;
	END IF;

	-- Lista para los tipos de cuenta de los Clientes
	IF(Par_NumLis = Lis_CtaCliente) THEN
		SELECT ClienteInstitucion INTO Var_ClienteInst
		FROM PARAMETROSSIS;

		SELECT 	`TipoCuentaID`,	`Descripcion`
		FROM 		TIPOSCUENTAS
		WHERE TipoCuentaID  NOT IN (SELECT TipoCuentaID FROM CUENTASAHO WHERE ClienteID = Var_ClienteInst GROUP BY TipoCuentaID);
	END IF;

	-- muestra una lista de todas las cuentas que no son bancarias
	IF(Par_NumLis = Lis_CtaCapitalizan) THEN
		SELECT TipoCuentaID,	Descripcion
		FROM TIPOSCUENTAS
		WHERE GeneraInteres = Con_SI;
	END IF;

    IF(Par_NumLis = Lis_TipCtasActivos) THEN
		SELECT 	`TipoCuentaID`,	`Descripcion`
		FROM 	TIPOSCUENTAS
		WHERE `Descripcion` LIKE CONCAT("%", Par_Descripcion, "%")
        AND Estatus = Estatus_Activo
		LIMIT 0, 15;
	END IF;

    IF(Par_NumLis = Lis_ComboTipCtasAct) THEN
		SELECT 	`TipoCuentaID`,	`Descripcion`
		FROM 	TIPOSCUENTAS
		WHERE Estatus = Estatus_Activo;
	END IF;

    IF(Par_NumLis = Lis_DifBancActivos) THEN
		SELECT 	`TipoCuentaID`,	`Descripcion`
			FROM 	TIPOSCUENTAS
			WHERE Esbancaria <> Con_SI
            AND Estatus = Estatus_Activo;
	END IF;

END TerminaStore$$