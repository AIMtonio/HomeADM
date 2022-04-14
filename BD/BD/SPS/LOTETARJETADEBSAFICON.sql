
-- LOTETARJETADEBSAFICON
DELIMITER ;
DROP PROCEDURE IF EXISTS `LOTETARJETADEBSAFICON`;
DELIMITER $$

CREATE PROCEDURE `LOTETARJETADEBSAFICON`(
    Par_LoteDebitoSAFIID    INT(11),
    Par_NumCon              INT(11),

    Par_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
	)
TerminaStore: BEGIN

DECLARE Var_Estatus				INT(11);
DECLARE	Var_TipoTarjetaDebID	INT(11);
DECLARE	Var_ClienteID			INT(11);
DECLARE	Var_CuentaAhoID			BIGINT(12);
DECLARE Var_TipoCuentaID		INT(11);
DECLARE Var_ComisionAnual		DECIMAL(14,2);
DECLARE Var_PagoComAnual		CHAR(1);
DECLARE Var_FPagoComAnual		DATE;
DECLARE Var_FechaProximoPag		DATE;
DECLARE Var_FechaActivacion		DATE;
DECLARE Var_LoteDebSAFIID       INT(11);            -- Lote de tarjetas a registrar
DECLARE Var_NumTarjetas         INT(11);            -- Cantidad de tarjetas a registrar
DECLARE Var_NumTransaccion      BIGINT(20);         -- Numero de transaccion
DECLARE Var_Contador            INT(11);            -- Contador auxiliar
DECLARE Var_NumSubBIN           VARCHAR(2);         -- SubBin del Tipo de tarjeta
DECLARE Var_NumBIN              VARCHAR(8);         -- Bin del tipo de tarjeta


DECLARE Con_Principal  		INT(11);
DECLARE Con_RutaArchivo     INT(11);
DECLARE Var_LoteDebitoID    INT(11);
DECLARE Var_FolFinal 		INT(11);
DECLARE Entero_Cero		 	INT(11);
DECLARE Cadena_Vacia		CHAR(1);
DECLARE Sta_Solici          INT(11);                -- Valor de estatus Tarjetas Solicitadas
DECLARE Con_TarPen          TINYINT;                -- Consulta de tarjetas pendientes.
DECLARE Con_InfoLote        TINYINT;                -- Consulta informacion de lote.

SET Con_Principal   :=1;
SET Con_RutaArchivo :=24;
SET	Cadena_Vacia	:= '';
SET	Entero_Cero		:= 0;
SET Sta_Solici      := 1;                           -- Valor de estatus Tarjetas Solicitadas
SET Con_TarPen      := 2;                           -- Consulta de tarjetas pendientes
SET Con_InfoLote    := 3;                           -- Consulta informacion de lote.

    IF(Par_NumCon = Con_RutaArchivo) THEN
        SELECT LoteDebSAFIID,   RutaNomArch
        FROM LOTETARJETADEBSAFI
            WHERE LoteDebSAFIID = Par_LoteDebitoSAFIID;
    END IF;

    -- Consulta de tarjetas pendientes para ETL de tarjetas
    IF(Par_NumCon = Con_TarPen) THEN
        SELECT      LOT.LoteDebSAFIID,      LOT.NumTarjetas,        TT.NumSubBIN,           TB.NumBIN,          LOT.NumTransaccion
            INTO    Var_LoteDebSAFIID,      Var_NumTarjetas,        Var_NumSubBIN,          Var_NumBIN,         Var_NumTransaccion
            FROM LOTETARJETADEBSAFI LOT
            INNER JOIN TIPOTARJETADEB TT ON TT.TipoTarjetaDebID = LOT.TipoTarjetaDebID
            INNER JOIN TARBINPARAMS TB ON TT.TarBinParamsID = TB.TarBinParamsID
            WHERE LOT.Estatus = Sta_Solici;

        SET Var_NumBIN := IFNULL(Var_NumBIN, Cadena_Vacia);
        SET Var_NumSubBIN := IFNULL(Var_NumSubBIN, Cadena_Vacia);
        SET Var_NumTarjetas := IFNULL(Var_NumTarjetas, Entero_Cero);

        DROP TABLE IF EXISTS TMP_TARDELOTESAFI;
        CREATE TEMPORARY TABLE TMP_TARDELOTESAFI (
            LoteDebSAFIID               INT(11),
            NumTarjeta                  INT(11),
            NumTransaccion              BIGINT(20),
            NumSubBIN                   CHAR(2),
            NumBIN                      CHAR(8),


            PRIMARY KEY(LoteDebSAFIID, NumTarjeta)
        );

        SET Var_Contador := 1;
        WHILE Var_Contador <= Var_NumTarjetas DO
            INSERT INTO TMP_TARDELOTESAFI
                SELECT Var_LoteDebSAFIID,   Var_Contador,   Var_NumTransaccion, Var_NumSubBIN,  Var_NumBIN;

            SET Var_Contador := Var_Contador + 1;
        END WHILE;

        SELECT NumBIN,         NumSubBIN,           NumTransaccion,             LoteDebSAFIID
            FROM TMP_TARDELOTESAFI
            WHERE NumTransaccion = Var_NumTransaccion;
    END IF;

    IF(Par_NumCon = Con_InfoLote) THEN
        SELECT      LOT.LoteDebSAFIID,      LOT.NumTarjetas,        TT.NumSubBIN,           TB.NumBIN,          LOT.NumTransaccion
            INTO    Var_LoteDebSAFIID,      Var_NumTarjetas,        Var_NumSubBIN,          Var_NumBIN,         Var_NumTransaccion
            FROM LOTETARJETADEBSAFI LOT
            INNER JOIN TIPOTARJETADEB TT ON TT.TipoTarjetaDebID = LOT.TipoTarjetaDebID
            INNER JOIN TARBINPARAMS TB ON TT.TarBinParamsID = TB.TarBinParamsID
            WHERE LOT.Estatus = Sta_Solici;

        SET Var_NumBIN := IFNULL(Var_NumBIN, Cadena_Vacia);
        SET Var_NumSubBIN := IFNULL(Var_NumSubBIN, Cadena_Vacia);
        SET Var_NumTarjetas := IFNULL(Var_NumTarjetas, Entero_Cero);

        SELECT Var_NumBIN AS Bin, Var_NumSubBIN AS SubBin;
    END IF;
END TerminaStore$$
