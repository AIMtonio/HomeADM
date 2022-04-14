-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMETROSCAJACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMETROSCAJACON`;DELIMITER $$

CREATE PROCEDURE `PARAMETROSCAJACON`(

    Par_EmpresaID           INT(11),
    Par_NumCon              TINYINT UNSIGNED,


    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
    )
TerminaStore:BEGIN





    DECLARE Con_Principal           INT;
    DECLARE Con_ParmApoyoEsc        INT;
    DECLARE Con_VersionWS           INT;


    SET Con_Principal           :=1;
    SET Con_ParmApoyoEsc        :=2;
    SET Con_VersionWS           :=3;




        IF(Par_NumCon = Con_Principal) THEN
            SELECT  EmpresaID,                  CtaProtecCre,               CtaProtecCta,       HaberExsocios,           CtaContaPROFUN,
                    TipoCtaProtec,              CtaOrdinaria,
                    FORMAT(MontoMaxProtec,2) AS MontoMaxProtec,
                    FORMAT(MontoPROFUN,2) AS MontoPROFUN,
                    FORMAT(AporteMaxPROFUN,2) AS AporteMaxPROFUN,           EdadMaximaSRVFUN,   TiempoMinimoSRVFUN,      MesesValAhoSRVFUN,
                    FORMAT(SaldoMinMesSRVFUN,2) AS SaldoMinMesSRVFUN,
                    FORMAT(MontoApoyoSRVFUN,2) AS MontoApoyoSRVFUN,         FORMAT(MonApoFamSRVFUN,2) AS MonApoFamSRVFUN,
                    PerfilAutoriSRVFUN,         CtaContaSRVFUN,             RolAutoApoyoEsc,    TipoCtaApoyoEscMay,      TipoCtaApoyoEscMen,
                    CtaContaApoyoEsc,           MesInicioAhoCons,           FORMAT(MontoMinMesApoyoEsc,2) AS MontoMinMesApoyoEsc,
                    CompromisoAhorro,           MaxAtraPagPROFUN,           PerfilCancelPROFUN, PorcentajeCob,      CoberturaMin,
                    PerfilAutoriProtec,         TipoCtaBeneCancel,      CuentaVista,        CtaContaPerdida,        EjecutivoFR,
                    CCHaberesEx,                CCProtecAhorro,         CCServifun,         CCApoyoEscolar,         CCContaPerdida,
                    TipoCtaProtecMen,           EdadMinimaCliMen,       EdadMaximaCliMen,   FORMAT(GastosRural,2) as GastosRural,
                    FORMAT(GastosUrbana,2) as GastosUrbana,             IDGastoAlimenta,    GastosPasivos,          puntajeMinimo,
                    idGastoAlimenta,            VersionWS,              RolCancelaCheque,   CodCooperativa,         CodMoneda,
                    CodUsuario,                 PermiteAdicional,       TipoProdCap,        AntigueSocio,           MontoAhoMes,
                    ImpMinParSoc,               MesesEvalAho,           ValidaCredAtras,    ValidaGaranLiq,         MesesConsPago,
                    FORMAT(montoMaxActCom,2) AS montoMaxActCom,  		FORMAT(montoMinActCom,2) AS montoMinActCom
            FROM    PARAMETROSCAJA
            WHERE   EmpresaID = Par_EmpresaID;
        END IF;



        IF(Par_NumCon = Con_ParmApoyoEsc) THEN
            SELECT  EmpresaID,              RolAutoApoyoEsc,      TipoCtaApoyoEscMay,       TipoCtaApoyoEscMen,
                    CtaContaApoyoEsc,       TiempoMinApoyoEsc,    FORMAT(MontoMinMesApoyoEsc,2) AS MontoMinMesApoyoEsc
            FROM    PARAMETROSCAJA
            WHERE   EmpresaID = Par_EmpresaID;
        END IF;



        IF(Par_NumCon = Con_VersionWS) THEN
            SELECT  VersionWS
            FROM    PARAMETROSCAJA
            WHERE   EmpresaID = Par_EmpresaID;
        END IF;

END TerminaStore$$