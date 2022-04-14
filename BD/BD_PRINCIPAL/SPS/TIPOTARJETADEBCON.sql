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
	Par_NumTarjeta		VARCHAR(16),		-- Parametro de Numero de tarjeta 16 digitos
	Par_NumCon			 TINYINT UNSIGNED,	-- Parametro de Numero de Consulta
	Par_EmpresaID		 INT(11),				-- Parametro de Auditoria

	Aud_Usuario			INT(11),				-- Parametro de Auditoria
	Aud_FechaActual		DATETIME,				-- Parametro de Auditoria
	Aud_DireccionIP		VARCHAR(15),			-- Parametro de Auditoria
	Aud_ProgramaID		VARCHAR(50),			-- Parametro de Auditoria
	Aud_Sucursal		INT(11),				-- Parametro de Auditoria
	Aud_NumTransaccion	BIGINT(20)				-- Parametro de Auditoria
	)
TerminaStore: BEGIN
-- declaracion de variables
DECLARE Var_NumSubBIN		CHAR(2);			-- Numero del SubBIN
DECLARE Var_NumBIN 			CHAR(6);			-- Numero de BIN
DECLARE Var_TipoCuenta  	INT(11);			-- Variable de Tipo de Cuenta
DECLARE	Cadena_Vacia		CHAR(1);			-- Cadena Vacia
DECLARE	Fecha_Vacia			DATE;				-- Fecha Vacia
DECLARE	Entero_Cero			INT(11);			-- Entero Cero
DECLARE	Con_Principal		INT(11);			-- Consulta Principal
DECLARE	Con_Foranea			INT(11);			-- Consulta foranea
DECLARE Estatus_Activo		CHAR(1);			-- Estatus Activo
DECLARE Con_TipoTarjetaDebito INT(11);			-- Consulta de Tipo Tarjeta Debito
DECLARE Con_TarjetaDebito 	INT(11);			-- Consulta de Tarjeta Debito
DECLARE EstatusD	        CHAR(1);		-- Estatus Debito
DECLARE EstatusC	        CHAR(1);		-- Estatus Credito
DECLARE TipoCred			VARCHAR(8);		-- Tipo Credito
DECLARE TipoDeb				VARCHAR(7);		-- Tipo Debito
DECLARE Con_ConfSubBIN		INT(11);		-- Tipo de consulta por SubBIN


SET	Cadena_Vacia			:= '';
SET	Fecha_Vacia				:= '1900-01-01';
SET	Entero_Cero				:= 0;
SET	Con_Principal			:= 1;
SET Con_Foranea				:= 2;
SET Estatus_Activo			:='A';
SET Con_TipoTarjetaDebito 	:=3;
SET Con_TarjetaDebito 		:=4;
SET Con_ConfSubBIN			:= 5;

SET EstatusD				:= 'D';
SET EstatusC				:= 'C';
SET TipoCred				:= 'CREDITO';
SET TipoDeb					:= 'DEBITO';

IF(Par_NumCon = Con_TipoTarjetaDebito) THEN
   SELECT TipoTarjetaDebID, 	Descripcion, 		CompraPOSLinea,	 	Estatus,		IdentificacionSocio,
		  TipoProsaID,			ColorTarjeta,		VigenciaMeses,		TipoTarjeta,	TasaFija,
          MontoAnualidad,		CobraMora,			TipCobComMorato,	FactorMora,		CobraFaltaPago,
          TipCobComFalPago,		FactorFaltaPago,	PorcPagoMin,		MontoCredito,	ProductoCredito,
          CobComisionAper,		TipoCobComAper,     FacComisionAper,	TarBinParamsID,	TipoCore,
          UrlCore,				NumSubBIN,			PatrocinadorID,		TipoMaquilador
		FROM TIPOTARJETADEB
		 WHERE TipoTarjetaDebID=	Par_TipoTarjetaDebID;
END IF;


IF(Par_NumCon = Con_TarjetaDebito) THEN
  SELECT TipoTarjetaDebID, Descripcion,IdentificacionSocio
		FROM TIPOTARJETADEB;
END IF;

-- CONFIGURACIÓN DE SUBBIN
IF(Par_NumCon = Con_ConfSubBIN)THEN
	SET Var_NumSubBIN := SUBSTRING(Par_NumTarjeta,7,2);
	SET Var_NumBIN := SUBSTRING(Par_NumTarjeta,1,6);
	SELECT TT.TipoTarjetaDebID,	TT.TarBinParamsID,	TT.TipoCore,	TT.UrlCore, TT.NumSubBIN
		FROM TIPOTARJETADEB TT
			INNER JOIN TARBINPARAMS TB ON TB.TarBinParamsID = TT.TarBinParamsID
		WHERE TT.NumSubBIN = Var_NumSubBIN
			AND TB.NumBIN = Var_NumBIN;
END IF;

END TerminaStore$$
