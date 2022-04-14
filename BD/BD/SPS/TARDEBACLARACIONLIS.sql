-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBACLARACIONLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBACLARACIONLIS`;DELIMITER $$

CREATE PROCEDURE `TARDEBACLARACIONLIS`(
#SP PARA LISTA DE ACLARACIONES TARJETAS
	Par_ReporteID       VARCHAR(15), 		-- Parametro de Reporte ID
    Par_TarjetaDebID    VARCHAR(16),		-- Parametro de Tarjeta Deb ID
    Par_TipoTarjeta		CHAR(1),			-- Parametro de Tipo Tarjeta
    Par_Fecha           VARCHAR(12),		-- Parametro Fecha
    Par_NumLis          TINYINT UNSIGNED,	-- Parametro de Numero Lista

    Par_EmpresaID       INT(11),			-- Parametro de Auditoria
    Aud_Usuario         INT(11),			-- Parametro de Auditoria
    Aud_FechaActual     DATETIME,			-- Parametro de Auditoria
    Aud_DireccionIP     VARCHAR(15),		-- Parametro de Auditoria
    Aud_ProgramaID      VARCHAR(50),		-- Parametro de Auditoria
    Aud_Sucursal        INT(11),			-- Parametro de Auditoria
    Aud_NumTransaccion  BIGINT(20)			-- Parametro de Auditoria
)
TerminaStore: BEGIN

-- Declaracion de Constantes

DECLARE Cadena_Vacia        CHAR(1);		-- Cadena Vacia
DECLARE Fecha_Vacia         DATE;			-- Fecha Vacia
DECLARE Entero_Cero			INT(11);		-- Entero Cero
DECLARE Lis_Principal       INT(11);		-- Lista Principal
DECLARE Lis_Transacciones   INT(11);		-- Lista Transacciones

DECLARE Var_CuentaAhoID     BIGINT(12);		-- Variable de Cuenta AhorroID
DECLARE Mov_CompraNormal    INT(11);
DECLARE Mov_RetiroEfectivo	INT(11);
DECLARE Mov_RetiroCajero    INT(11);
DECLARE Mov_ComisionRetiro  INT(11);
DECLARE Mov_IVAComRet       INT(11);
DECLARE Mov_ComConSaldo     INT(11);
DECLARE Mov_IVAComConSaldo  INT(11);
DECLARE Mov_CompraRetiro	INT(11);
DECLARE EstatusP    		CHAR(1);
DECLARE Lis_TransCred	    INT(11);

-- Asignacion de Constantes
SET Cadena_Vacia		:= '';              -- Cadena Vacia
SET Fecha_Vacia			:= '1900-01-01';    -- Fecha Vacia
SET Entero_Cero			:= 0;               -- Entero Cero
SET Lis_Principal		:= 1;               -- Tipo de Lista Principal
SET Lis_Transacciones 	:= 3;

SET Mov_CompraNormal    := 17;  -- compr normal
SET Mov_RetiroEfectivo	:= 18;	-- Movimiento Retiro efectivo
SET Mov_RetiroCajero    := 20;  -- retiro cajero
SET Mov_ComisionRetiro  := 21;  -- comision por retiro en ATM
SET Mov_IVAComRet       := 22;  -- iva comision por retiro en ATM
SET Mov_ComConSaldo     := 86;  -- comision por consulta de saldo
SET Mov_CompraRetiro	:= 87; 	-- Movimientos Compra Retiro
SET Mov_IVAComConSaldo  := 88;  -- iva comision por consulta de saldo
SET EstatusP			:= 'P';				-- Estatus de la tarjeta en movs
SET Lis_TransCred	 	:= 2;	-- Lista Transaccion Credito

    IF(Par_NumLis = Lis_Principal) THEN
        SELECT ReporteID, TarjetaDebID
            FROM TARDEBACLARACION
            WHERE ReporteID LIKE CONCAT("%", Par_ReporteID, "%")
            AND TipoTarjeta = Par_TipoTarjeta
            LIMIT 0, 15;
    END IF;


	IF ( Par_NumLis = Lis_TransCred ) THEN
        SELECT
            NumTransaccion, CONVERT(CONCAT( NumTransaccion, '-', Nombrecomercio,'-',Ciudad,'-', MontoOperacion), CHAR) AS Descripcion
        FROM TC_BITACORAMOVS
        WHERE
			TarjetaCredID = Par_TarjetaDebID AND
			FechaOperacion = Par_Fecha
            AND Estatus = EstatusP;
    END IF;

    IF ( Par_NumLis = Lis_Transacciones ) THEN
        SELECT
            CuentaAhoID       INTO Var_CuentaAhoID
        FROM TARJETADEBITO
        WHERE TarjetaDebID = Par_TarjetaDebID;

        SELECT
            NumTransaccion, CONVERT(CONCAT( NumTransaccion, '-', DescripcionMov,'-', CantidadMov), CHAR) AS Descripcion
        FROM CUENTASAHOMOV
        WHERE
			CuentaAhoID = Var_CuentaAhoID AND
			Fecha = Par_Fecha
            AND TipoMovAhoID IN (Mov_CompraNormal, Mov_RetiroCajero,
									Mov_RetiroEfectivo,
									Mov_ComisionRetiro,
									Mov_IVAComRet,
									Mov_ComConSaldo,
									Mov_CompraRetiro,
									Mov_IVAComConSaldo);

    END IF;

END TerminaStore$$