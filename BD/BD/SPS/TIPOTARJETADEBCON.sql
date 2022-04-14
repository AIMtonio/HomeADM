-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOTARJETADEBCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOTARJETADEBCON`;
DELIMITER $$

CREATE PROCEDURE `TIPOTARJETADEBCON`(
#SP PARA CONSULTA DE TIPO TARJETA DEBITO Y CREDITO

	Par_TipoTarjetaDebID VARCHAR(50),		-- Parametro de ID Tipo Tarjeta
	Par_CuentaAhoID		 BIGINT(12),		-- Parametro de Cuenta de Ahorro ID
	Par_NumCon			 TINYINT UNSIGNED,	-- Parametro de Numero de Consulta
	Par_EmpresaID		 INT,				-- Parametro de Auditoria

	Aud_Usuario			INT,				-- Parametro de Auditoria
	Aud_FechaActual		DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP		VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID		VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal		INT,				-- Parametro de Auditoria
	Aud_NumTransaccion	BIGINT				-- Parametro de Auditoria
	)
TerminaStore: BEGIN
-- declaracion de variables
DECLARE Var_TipoCuenta  	INT;			-- Variable de Tipo de Cuenta
DECLARE	Cadena_Vacia		CHAR(1);		-- Cadena Vacia
DECLARE	Fecha_Vacia			DATE;			-- Fecha Vacia
DECLARE	Entero_Cero			INT;			-- Entero Cero
DECLARE	Con_Principal		INT;			-- Consulta Principal
DECLARE	Con_Foranea			INT;			-- Consulta foranea
DECLARE Estatus_Activo		CHAR(1);		-- Estatus Activo
DECLARE Con_TipoTarjetaDebito INT;			-- Consulta de Tipo Tarjeta Debito
DECLARE Con_TarjetaDebito 	INT;			-- Consulta de Tarjeta Debito
DECLARE EstatusD	        CHAR(1);		-- Estatus Debito
DECLARE EstatusC	        CHAR(1);		-- Estatus Credito
DECLARE TipoCred			VARCHAR(8);		-- Tipo Credito
DECLARE TipoDeb				VARCHAR(7);		-- Tipo Debito


SET	Cadena_Vacia			:= '';
SET	Fecha_Vacia				:= '1900-01-01';
SET	Entero_Cero				:= 0;
SET	Con_Principal			:= 1;
SET Con_Foranea				:= 2;
SET Estatus_Activo			:='A';
SET Con_TipoTarjetaDebito 	:=3;
SET Con_TarjetaDebito 		:=4;
SET EstatusD				:= 'D';
SET EstatusC				:= 'C';
SET TipoCred				:= 'CREDITO';
SET TipoDeb					:= 'DEBITO';

SELECT TipoCuentaID INTO Var_TipoCuenta
	FROM CUENTASAHO
		WHERE cuentaAhoID=Par_CuentaAhoID;

IF(Par_NumCon = Con_Principal) THEN
	SELECT TipoTarjetaDebID, Descripcion,IdentificacionSocio,CASE WHEN TipoTarjeta = EstatusD THEN TipoDeb
																WHEN TipoTarjeta = EstatusC THEN  TipoCred
																ELSE Cadena_Vacia END AS TipoTarjeta,
			TipoCore
		FROM TIPOTARJETADEB
		WHERE TipoTarjetaDebID=	Par_TipoTarjetaDebID;
END IF;


IF(Par_NumCon = Con_Foranea) THEN
	SELECT TT.TipoTarjetaDebID,TT.Descripcion,Com.MontoComision, TT.IdentificacionSocio
		FROM TIPOTARJETADEB TT
	INNER JOIN TIPOSCUENTATARDEB TC ON TC.TipoTarjetaDebID=TT.TipoTarjetaDebID
	INNER JOIN TARDEBESQUEMACOM Com ON Com.TipoCuentaID=TC.TipoCuentaID
		WHERE TT.TipoTarjetaDebID=	Par_TipoTarjetaDebID
			AND TT.Estatus=Estatus_Activo
			AND TC.TipoCuentaID=Var_TipoCuenta;
END IF;


IF(Par_NumCon = Con_TipoTarjetaDebito) THEN
   SELECT TipoTarjetaDebID, 	Descripcion, 		CompraPOSLinea,	 	Estatus,		IdentificacionSocio,
		  TipoProsaID,			ColorTarjeta,		VigenciaMeses,		TipoTarjeta,	TasaFija,
          MontoAnualidad,		CobraMora,			TipCobComMorato,	FactorMora,		CobraFaltaPago,
          TipCobComFalPago,		FactorFaltaPago,	PorcPagoMin,		MontoCredito,	ProductoCredito,
          CobComisionAper,		TipoCobComAper,     FacComisionAper,	TarBinParamsID,	TipoCore,
          UrlCore,				TipoMaquilador
		FROM TIPOTARJETADEB
		 WHERE TipoTarjetaDebID =	Par_TipoTarjetaDebID;
END IF;


IF(Par_NumCon = Con_TarjetaDebito) THEN
  SELECT TipoTarjetaDebID, Descripcion,IdentificacionSocio
		FROM TIPOTARJETADEB;
END IF;

END TerminaStore$$
