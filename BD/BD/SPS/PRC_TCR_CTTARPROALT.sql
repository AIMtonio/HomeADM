-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PRC_TCR_CTTARPROALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PRC_TCR_CTTARPROALT`;DELIMITER $$

CREATE PROCEDURE `PRC_TCR_CTTARPROALT`(
)
BEGIN

	DECLARE	Fec_Vencimiento	DATE;



	DECLARE	Fec_Vacia		DATE;
	DECLARE	String_Vacio	CHAR(1);
	DECLARE	Tip_TarjCred	CHAR(1);
    DECLARE FechaAct		DATETIME;
	DECLARE Sta_Tarj		INT;
    DECLARE Moneda_Vacia	DECIMAL(12,2);
    DECLARE Ent_Vacio		INT;
	DECLARE Programa		CHAR(11);
    DECLARE Empresa			INT;
    DECLARE Num_Transa		BIGINT;


	SET	Fec_Vacia		:= '1900-01-01';
	SET	String_Vacio	:= '';
    SET Programa		:= 'PROCESO_ISS';
    SET Moneda_Vacia	:= 0.00;
    SET Ent_Vacio		:= 0;
    SET Sta_Tarj		:= 3;
    SET Empresa			:= 1;
    SET FechaAct		:= NOW();

	CALL TRANSACCIONESPRO( Num_Transa);

	INSERT INTO TARJETADEBITO(
				TarjetaDebID,		LoteDebitoID,		FechaRegistro,		FechaVencimiento,		FechaActivacion,
				Estatus,			ClienteID,			CuentaAhoID,		FechaBloqueo,			MotivoBloqueo,
				FechaCancelacion,	MotivoCancelacion,	FechaDesbloqueo,	MotivoDesbloqueo,		NIP,
				NombreTarjeta,		Relacion,			SucursalID,			TipoTarjetaDebID,		NoDispoDiario,
				NoDispoMes,			MontoDispoDiario,	MontoDispoMes,		NoConsultaSaldoMes,		NoCompraDiario,
				NoCompraMes,		MontoCompraDiario,	MontoCompraMes,		TipoCobro,				PagoComAnual,
				FPagoComAnual,		EmpresaID,			Usuario,			FechaActual,			DireccionIP,
				ProgramaID,			Sucursal,			NumTransaccion)
		SELECT
				LEFT(DET.Dao_Campo12,16),	Dao_NumLote,				FechaAct,						CONCAT(SUBSTRING(DET.Dao_Campo20,5,2),'/',SUBSTRING(DET.Dao_Campo20,3,2)),	Fec_Vacia,
				Sta_Tarj,					Ent_Vacio,					Ent_Vacio,						Fec_Vacia,																	Ent_Vacio,
                Fec_Vacia,					Ent_Vacio,					Fec_Vacia,						Ent_Vacio,																	String_Vacio,
				String_Vacio,				String_Vacio,				CAST(DET.Dao_Campo7 AS SIGNED),	TTD.TipoTarjetaDebID,														Ent_Vacio,
				Ent_Vacio,					Moneda_Vacia,				Moneda_Vacia,					Ent_Vacio,																	Ent_Vacio,
				Ent_Vacio,					Moneda_Vacia,				Moneda_Vacia,					String_Vacio,																String_Vacio,
				Fec_Vacia,					Empresa,					Ent_Vacio,						FechaAct,																	String_Vacio,
				Programa,				CAST(DET.Dao_Campo7 AS SIGNED),	Num_Transa
			FROM TCR_DETARCOUT_ADM DET
			INNER JOIN TIPOTARJETADEB TTD
				ON	TTD.TipoProsaID	= CAST(DET.Dao_Campo18 AS SIGNED)
				AND	DET.Dao_Status	= 'N'
				ORDER BY DET.Dao_Consecutivo  ASC;
END$$