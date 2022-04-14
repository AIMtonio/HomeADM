-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDOPEINUSUALESCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDOPEINUSUALESCON`;
DELIMITER $$

CREATE PROCEDURE `PLDOPEINUSUALESCON`(

    Par_OpeInusualID        BIGINT(20),
    Par_FechaActual         DATETIME,
    Par_NumCon              TINYINT UNSIGNED,

    Par_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
        )
TerminaStore: BEGIN


DECLARE ClaveEntCas     CHAR(7);
DECLARE ClaveOrgSup     CHAR(3);
DECLARE FechaNombre     INT(11);
DECLARE Var_NombreRep   VARCHAR(45);
DECLARE Var_TipoRepXMLPLD VARCHAR(50);

DECLARE Cadena_Vacia    CHAR(1);
DECLARE Fecha_Vacia     DATE;
DECLARE Entero_Cero     INT;
DECLARE Con_Principal   INT;
DECLARE Con_Foranea     INT;
DECLARE Con_NombArch    INT;
DECLARE Punto           CHAR(1);
DECLARE TipoReporte     INT;


DECLARE NoAsignada      CHAR(1);
DECLARE Excelente       CHAR(1);
DECLARE Buena           CHAR(1);
DECLARE Regular         CHAR(1);
DECLARE DesNoAsignada   VARCHAR(11);
DECLARE DesExcelente    VARCHAR(9);
DECLARE DesBuena        VARCHAR(5);
DECLARE DesRegular      VARCHAR(8);
DECLARE Soltero         CHAR(1);
DECLARE CasadoBS        CHAR(2);
DECLARE CasadoBM        CHAR(2);
DECLARE CasadoCC        CHAR(2);
DECLARE Viudo           CHAR(1);
DECLARE Divorciado      CHAR(1);
DECLARE Separado        CHAR(2);
DECLARE UnionLibre      CHAR(1);
DECLARE DesSoltero      VARCHAR(7);
DECLARE DesCasadoBS     VARCHAR(23);
DECLARE DesCasadoBM     VARCHAR(27);
DECLARE DesCasadoCC     VARCHAR(48);
DECLARE DesViudo        VARCHAR(5);
DECLARE DesDivorciado   VARCHAR(10);
DECLARE DesSeparado     VARCHAR(8);
DECLARE DesUnionLibre   VARCHAR(11);
DECLARE Spei            CHAR(1);
DECLARE Cheque          CHAR(1);
DECLARE OrdenPago       CHAR(1);
DECLARE Efectivo        CHAR(1);
DECLARE DesSpei         VARCHAR(4);
DECLARE DesCheque       VARCHAR(6);
DECLARE DesOrdenPago    VARCHAR(13);
DECLARE DesEfectivo     VARCHAR(8);
DECLARE Ing1            VARCHAR(4);
DECLARE Ing2            VARCHAR(4);
DECLARE Ing3            VARCHAR(4);
DECLARE Ing4            VARCHAR(4);
DECLARE Valor_Ing1      VARCHAR(15);
DECLARE Valor_Ing2      VARCHAR(15);
DECLARE Valor_Ing3      VARCHAR(16);
DECLARE Valor_Ing4      VARCHAR(15);
DECLARE Decimal_Cero    DECIMAL(14,2);
DECLARE OficialSI       CHAR(1);
DECLARE Ingresos        CHAR(1);
DECLARE EstatusVigente  CHAR(1);
DECLARE EsCliente       VARCHAR(3);
DECLARE EsUsServ        VARCHAR(3);
DECLARE EsUsServ2        VARCHAR(3);
DECLARE EsNA            VARCHAR(3);
DECLARE TipoRepSITI     CHAR(1);
DECLARE TipoRepXML      CHAR(1);

DECLARE Var_ClienteID       INT(11);
DECLARE Var_UsuarioServicioID   INT(11);
DECLARE Var_CreditoID       BIGINT(12);
DECLARE Var_OcupacionID     INT(11);
DECLARE var_CalificaCredito CHAR(1);
DECLARE Var_SucursalOrigen  INT(11);
DECLARE Var_FechaNacimiento DATE;
DECLARE Var_EstadoCivil     VARCHAR(48);
DECLARE Var_Edad            INT(11);
DECLARE Var_DescOcupacion   TEXT;
DECLARE Var_NombreSucursal  VARCHAR(50);
DECLARE Var_GradoEscolarID  INT(11);
DECLARE Var_DesGradoEscolar VARCHAR(50);
DECLARE Var_Ingresos        DECIMAL(14,2);
DECLARE Var_IngAproxMes     VARCHAR(20);
DECLARE Var_FechaSistema    DATE;
DECLARE Var_EstadoID        INT(11);
DECLARE Var_MunicipioID     INT(11);
DECLARE Var_LocalidadID     INT(11);
DECLARE Var_NombreLocalidad VARCHAR(200);
DECLARE Var_Calificacion    VARCHAR(12);
DECLARE Var_ProdCredito     INT(4);
DECLARE Var_DesProdCredito  VARCHAR(100);
DECLARE Var_GrupoID         INT(11);
DECLARE Var_NombreGrupo     VARCHAR(200);
DECLARE Var_ProductoCredito VARCHAR(150);
DECLARE Var_GrupoNoSoli     VARCHAR(250);
DECLARE Var_Localidad       VARCHAR(250);
DECLARE Var_TipoPersonaSAFI VARCHAR(50);    -- Almacena el tipo de persona SAFI: CTE. Cliente, USU. Usuario de serv, NA. no se completo registro
DECLARE Var_ClavePersonaInv INT(11);
DECLARE Var_ProgramaID      VARCHAR(50);

SET Cadena_Vacia    := '';
SET Fecha_Vacia     := '1900-01-01';
SET Entero_Cero     := 0;
SET Con_Principal   := 1;
SET Con_NombArch    := 2;
SET Punto           := '.';
SET TipoReporte     := 2;


SET NoAsignada      :='N';
SET Excelente       :='A';
SET Buena           :='B';
SET Regular         :='C';
SET DesNoAsignada   :='NO ASIGNADA';
SET DesExcelente    :='EXCELENTE';
SET DesBuena        :='BUENA';
SET DesRegular      :='REGULAR';
SET Soltero         :='S';
SET CasadoBS        :='CS';
SET CasadoBM        :='CM';
SET CasadoCC        :='CC';
SET Viudo           :='V';
SET Divorciado      :='D';
SET Separado        :='SE';
SET UnionLibre      :='U';
SET DesSoltero      :='SOLTERO';
SET DesCasadoBS     :='CASADO BIENES SEPARADOS';
SET DesCasadoBM     :='CASADO BIENES MANCOMUNADOS';
SET DesCasadoCC     :='CASADO BIENES MANCOMUNADOS CON CAPITULACION';
SET DesViudo        :='VIUDO';
SET DesDivorciado   :='DIVORSIADO';
SET DesSeparado     :='SEPARADO';
SET DesUnionLibre   :='UNION LIBRE';
SET Spei            :='S';
SET Cheque          :='C';
SET OrdenPago       :='O';
SET Efectivo        :='E';
SET DesSpei         :='SPEI';
SET DesCheque       :='CHEQUE';
SET DesOrdenPago    :='ORDEN DE PAGO';
SET DesEfectivo     :='EFECTIVO';
SET Ing1            :='Ing1';
SET Ing2            :='Ing2';
SET Ing3            :='Ing3';
SET Ing4            :='Ing4';
SET Valor_Ing1      :='Menos de 20,000';
SET Valor_Ing2      :='20,001 a 50,000';
SET Valor_Ing3      :='50,001 a 100,000';
SET Valor_Ing4      :='Mayor a 100,000';
SET Decimal_Cero    :=0.00;
SET OficialSI       :='S';
SET Ingresos        :='I';
SET EstatusVigente  :='V';
SET EsCliente       := 'CTE';
SET EsUsServ        := 'USU';
SET EsUsServ2		:= 'USS';
SET EsNA            := 'NA';
SET TipoRepSITI     := '1';
SET TipoRepXML      := '2';

IF(Par_NumCon = Con_Principal) THEN

    SELECT  CreditoID,      ClavePersonaInv,        TipoPersonaSAFI,        ProgramaID
      INTO  Var_CreditoID,  Var_ClavePersonaInv,    Var_TipoPersonaSAFI,    Var_ProgramaID
        FROM PLDOPEINUSUALES
            WHERE OpeInusualID =Par_OpeInusualID;

    SET Var_CreditoID := IFNULL(Var_CreditoID,Entero_Cero);

    IF(Var_ClavePersonaInv>Entero_Cero)THEN
        IF(Var_TipoPersonaSAFI=EsCliente)THEN
            SET Var_ClienteID := Var_ClavePersonaInv;
        END IF;

        IF(Var_TipoPersonaSAFI IN (EsUsServ,EsUsServ2))THEN
            SET Var_UsuarioServicioID := Var_ClavePersonaInv;
        END IF;

        IF(Var_TipoPersonaSAFI=EsNA)THEN
            SET Var_ClavePersonaInv := Entero_Cero;
        END IF;
    END IF;

    # ORIGEN DE LA DETECCIÓN
    SET Var_ProgramaID := (
            CASE Var_ProgramaID
                WHEN '/microfin/catalogoCliente.htm' THEN UPPER(FNGENERALOCALE('safilocale.cliente'))
                WHEN '/microfin/prospectosCatalogo.htm' THEN 'PROSPECTO'
                WHEN '/microfin/usuarioServiciosCatalogo.htm' THEN 'USUARIO DE SERV.'
                WHEN '/microfin/avalesCatalogo.htm' THEN 'AVAL'
                WHEN '/microfin/proveedoresCatalogo.htm' THEN 'PROVEEDOR'
                WHEN '/microfin/obligadosSolidariosCatalogo.htm' THEN 'OBLIGADO SOL.'
                WHEN '/microfin/catalogoCuentasPersona.htm' THEN 'RELACIONADO A LA CTA.'
            ELSE 'PERS. DESCONOCIDA.'
            END
            );
    # TIPO DE PERSONA DETECTADA.
    SET Var_TipoPersonaSAFI := (
            CASE Var_TipoPersonaSAFI
                WHEN 'AVA' THEN 'AVAL'
                WHEN 'CTE' THEN UPPER(FNGENERALOCALE('safilocale.cliente'))
                WHEN 'NA' THEN 'NO REGISTRADO.'
                WHEN 'USU' THEN 'USUARIO DE SERV.'
                WHEN EsUsServ2 THEN 'USUARIO DE SERV.'
                WHEN 'PRO' THEN 'PROSPECTO'
                WHEN 'PRV' THEN 'PROVEEDOR'
                WHEN 'OBS' THEN 'OBLIGADO SOL.'
                WHEN 'REL' THEN 'RELACIONADO A LA CTA.'
            ELSE 'PERS. DESCONOCIDA.'
            END
            );
    SET Var_ClienteID := IFNULL(Var_ClienteID,Entero_Cero);
    SET Var_UsuarioServicioID := IFNULL(Var_UsuarioServicioID,Entero_Cero);
    SET Var_ClavePersonaInv := IFNULL(Var_ClavePersonaInv,Entero_Cero);

    SELECT FechaSistema INTO Var_FechaSistema
        FROM PARAMETROSSIS;

    SET Var_FechaSistema := IFNULL(Var_FechaSistema,Fecha_Vacia);


    IF(Var_ClienteID>Entero_Cero)THEN

        SELECT OcupacionID,
            CASE CalificaCredito
                WHEN NoAsignada THEN DesNoAsignada
                WHEN Excelente THEN DesExcelente
                WHEN Buena THEN DesBuena
                WHEN Regular THEN DesRegular
            END,
            SucursalOrigen, FechaNacimiento,
            CASE EstadoCivil
                WHEN Soltero THEN DesSoltero
                WHEN CasadoBS THEN DesCasadoBS
                WHEN CasadoBM THEN DesCasadoBM
                WHEN CasadoCC THEN DesCasadoCC
                WHEN Viudo THEN DesViudo
                WHEN Divorciado THEN DesDivorciado
                WHEN Separado THEN DesSeparado
                WHEN UnionLibre THEN DesUnionLibre
            END,
            DATE_FORMAT(FROM_DAYS(TO_DAYS(Var_FechaSistema)-TO_DAYS(FechaNacimiento)), '%Y')+Entero_Cero
          INTO  Var_OcupacionID, Var_Calificacion, Var_SucursalOrigen, Var_FechaNacimiento, Var_EstadoCivil,
                Var_Edad
            FROM CLIENTES
                WHERE ClienteID = Var_ClienteID;

        SET Var_OcupacionID     :=IFNULL(Var_OcupacionID,Entero_Cero);
        SET Var_CalificaCredito :=IFNULL(Var_CalificaCredito,Cadena_Vacia);
        SET Var_SucursalOrigen  :=IFNULL(Var_SucursalOrigen,Entero_Cero);
        SET Var_FechaNacimiento :=IFNULL(Var_FechaNacimiento, Fecha_Vacia);
        SET Var_EstadoCivil     :=IFNULL(Var_EstadoCivil,Cadena_Vacia);
        SET Var_Edad            :=IFNULL(Var_Edad,Entero_Cero);

        SET Var_DescOcupacion :=(SELECT IFNULL(Descripcion,Cadena_Vacia)
                                    FROM OCUPACIONES
                                        WHERE OcupacionID = Var_OcupacionID);

        SET Var_NombreSucursal :=(SELECT IFNULL(NombreSucurs,Cadena_Vacia)
                                    FROM SUCURSALES
                                        WHERE SucursalID = Var_SucursalOrigen);

        SET Var_GradoEscolarID :=(SELECT IFNULL(GradoEscolarID,Entero_Cero)
                                    FROM SOCIODEMOGRAL
                                        WHERE ClienteID = Var_ClienteID);

        SET Var_DesGradoEscolar :=(SELECT IFNULL(Descripcion,Cadena_Vacia)
                                    FROM CATGRADOESCOLAR
                                        WHERE GradoEscolarID = Var_GradoEscolarID);

        SELECT SUM(Monto) INTO Var_Ingresos
          FROM CLIDATSOCIOE Cte,
                CATDATSOCIOE dat
            WHERE Cte.ClienteID=Var_ClienteID
                AND Cte.CatSocioEID=dat.CatSocioEID
                AND dat.Tipo= Ingresos
            GROUP BY Cte.LinNegID
            LIMIT 1;

        SET Var_Ingresos :=IFNULL(Var_Ingresos,Decimal_Cero);

        SET Var_IngAproxMes :=IFNULL((SELECT CASE IngAproxMes
                                            WHEN Ing1 THEN Valor_Ing1
                                            WHEN Ing2 THEN Valor_Ing2
                                            WHEN Ing3 THEN Valor_Ing3
                                            WHEN Ing4 THEN Valor_Ing4
                                        END AS IngAproxMes
                                        FROM CONOCIMIENTOCTE
                                            WHERE ClienteID = Var_ClienteID),Cadena_Vacia);

        SELECT  EstadoID,       MunicipioID,        LocalidadID
        INTO    Var_EstadoID,   Var_MunicipioID,    Var_LocalidadID
            FROM DIRECCLIENTE
                WHERE ClienteID=Var_ClienteID
                AND Oficial = OficialSI;

        SET Var_EstadoID    :=IFNULL(Var_EstadoID,Entero_Cero);
        SET Var_MunicipioID :=IFNULL(Var_MunicipioID,Entero_Cero);
        SET Var_LocalidadID :=IFNULL(Var_LocalidadID, Entero_Cero);

        SET Var_NombreLocalidad :=(SELECT IFNULL(NombreLocalidad,Cadena_Vacia)
                                    FROM LOCALIDADREPUB
                                        WHERE EstadoID = Var_EstadoID
                                            AND MunicipioID = Var_MunicipioID
                                            AND LocalidadID = Var_LocalidadID);

        IF(Var_LocalidadID != Entero_Cero)THEN
            SET Var_Localidad :=CONCAT(Var_NombreLocalidad);
        ELSE
            SET Var_Localidad := Cadena_Vacia;
        END IF;

        SELECT  ProductoCreditoID
          INTO  Var_ProdCredito
            FROM CREDITOS
                WHERE CreditoID = Var_CreditoID;

        SET Var_ProdCredito     :=IFNULL(Var_ProdCredito,Entero_Cero);

        SET Var_DesProdCredito  :=(SELECT IFNULL(Descripcion,Cadena_Vacia)
                                    FROM PRODUCTOSCREDITO
                                        WHERE ProducCreditoID = Var_ProdCredito);

        IF(Var_ProdCredito != Entero_Cero)THEN
            SET Var_ProductoCredito:= CONCAT(Var_ProdCredito,' ',Var_DesProdCredito);
        ELSE
            SET Var_ProductoCredito:= Cadena_Vacia;
        END IF;

        SET Var_GrupoID :=(SELECT IFNULL(GrupoID,Entero_Cero)
                            FROM INTEGRAGRUPONOSOL
                                WHERE ClienteID = Var_ClienteID);

        SET Var_NombreGrupo :=(SELECT IFNULL(NombreGrupo,Cadena_Vacia)
                                FROM GRUPOSNOSOLIDARIOS
                                    WHERE GrupoID = Var_GrupoID);

        IF(Var_GrupoID != Entero_Cero)THEN
            SET Var_GrupoNoSoli :=CONCAT(Var_GrupoID,' ',Var_NombreGrupo);
        ELSE
            SET Var_GrupoNoSoli :=Cadena_Vacia;
        END IF;

    END IF;


    IF(Var_UsuarioServicioID>Entero_Cero)THEN
        SELECT
            OcupacionID,  SucursalOrigen, FechaNacimiento,
                EstadoID,   MunicipioID,    LocalidadID,
                DATE_FORMAT(FROM_DAYS(TO_DAYS(Var_FechaSistema)-TO_DAYS(FechaNacimiento)), '%Y')+Entero_Cero
        INTO Var_OcupacionID,  Var_SucursalOrigen, Var_FechaNacimiento,
                Var_EstadoID,   Var_MunicipioID,    Var_LocalidadID,
                Var_Edad
            FROM USUARIOSERVICIO
                WHERE UsuarioServicioID = Var_UsuarioServicioID;

        SET Var_OcupacionID     :=IFNULL(Var_OcupacionID,Entero_Cero);
        SET Var_SucursalOrigen  :=IFNULL(Var_SucursalOrigen,Entero_Cero);
        SET Var_FechaNacimiento :=IFNULL(Var_FechaNacimiento, Fecha_Vacia);
        SET Var_Edad            :=IFNULL(Var_Edad,Entero_Cero);
        SET Var_EstadoID        :=IFNULL(Var_EstadoID,Entero_Cero);
        SET Var_MunicipioID     :=IFNULL(Var_MunicipioID,Entero_Cero);
        SET Var_LocalidadID     :=IFNULL(Var_LocalidadID, Entero_Cero);

        SET Var_NombreLocalidad :=(SELECT IFNULL(NombreLocalidad,Cadena_Vacia)
                                    FROM LOCALIDADREPUB
                                        WHERE EstadoID = Var_EstadoID
                                            AND MunicipioID = Var_MunicipioID
                                            AND LocalidadID = Var_LocalidadID);

        IF(Var_LocalidadID != Entero_Cero)THEN
            SET Var_Localidad :=CONCAT(Var_NombreLocalidad);
        ELSE
            SET Var_Localidad := Cadena_Vacia;
        END IF;

        SET Var_DescOcupacion :=(SELECT IFNULL(Descripcion,Cadena_Vacia)
                                    FROM OCUPACIONES
                                        WHERE OcupacionID = Var_OcupacionID);

        SET Var_NombreSucursal :=(SELECT IFNULL(NombreSucurs,Cadena_Vacia)
                                    FROM SUCURSALES
                                        WHERE SucursalID = Var_SucursalOrigen);
    END IF;

    SET Var_DescOcupacion   :=IFNULL(Var_DescOcupacion,Cadena_Vacia);
    SET Var_Calificacion    :=IFNULL(Var_Calificacion,Cadena_Vacia);
    SET Var_DesGradoEscolar :=IFNULL(Var_DesGradoEscolar,Cadena_Vacia);
    SET Var_IngAproxMes     :=IFNULL(Var_IngAproxMes,Cadena_Vacia);
    SET Var_SucursalOrigen  :=IFNULL(Var_SucursalOrigen,Entero_Cero);
    SET Var_Edad            :=IFNULL(Var_Edad,Entero_Cero);
    SET Var_FechaNacimiento :=IFNULL(Var_FechaNacimiento, Fecha_Vacia);
    SET Var_EstadoCivil     :=IFNULL(Var_EstadoCivil,Cadena_Vacia);
    SET Var_Localidad       :=IFNULL(Var_Localidad,Cadena_Vacia);
    SET Var_ProductoCredito :=IFNULL(Var_ProductoCredito,Cadena_Vacia);
    SET Var_GrupoNoSoli     :=IFNULL(Var_GrupoNoSoli,Cadena_Vacia);
    SET Var_NombreSucursal  :=IFNULL(Var_NombreSucursal,Cadena_Vacia);
    SET Var_Ingresos        :=IFNULL(Var_Ingresos,Decimal_Cero);

    SELECT  OpeInusualID,       CatProcedIntID,     CatMotivInuID,      FechaDeteccion,     SucursalID,
            ClavePersonaInv,    NomPersonaInv,      EmpInvolucrado,     Frecuencia,         DesFrecuencia,
            DesOperacion,       Estatus,            ComentarioOC,       FechaCierre,        Fecha,
            CreditoID,          CuentaAhoID,        TransaccionOpe,     NaturaOperacion,    MontoOperacion,
            MonedaID,           Var_DescOcupacion,  Var_Calificacion,   Var_SucursalOrigen, Var_DesGradoEscolar,
            Var_IngAproxMes,    Var_Edad,           Var_FechaNacimiento,Var_EstadoCivil,    Var_Localidad,
            Var_ProductoCredito,Var_GrupoNoSoli,    Var_Ingresos,       Var_NombreSucursal, IFNULL(FormaPago,Cadena_Vacia) AS FormaPago,
            CONCAT(TRIM(TipoPersonaSAFI),'|',TRIM(Var_ProgramaID),'|',TRIM(Var_TipoPersonaSAFI)) AS TipoPersonaSAFI
      FROM  PLDOPEINUSUALES
        WHERE OpeInusualID = Par_OpeInusualID;

END IF;


IF(Par_NumCon = Con_NombArch) THEN
    SET FechaNombre :=(DATE_FORMAT(Par_FechaActual,'%y%m%d'));
    SET ClaveEntCas :=(SELECT ClaveEntCasfim FROM PARAMETROSPLD WHERE Estatus = EstatusVigente);
    SET ClaveOrgSup :=(SELECT ClaveOrgSupervisorExt FROM PARAMETROSPLD WHERE Estatus = EstatusVigente);

    SET Var_TipoRepXMLPLD := LEFT(FNPARAMGENERALES('TipoRepXMLPLD'),50);
    SET Var_NombreRep := CONVERT(CONCAT(TipoReporte,ClaveEntCas,FechaNombre),CHAR(30));

    IF(Var_TipoRepXMLPLD = TipoRepXML)THEN
        UPDATE REPORTESXML SET NombreArchivo = Var_NombreRep WHERE ReporteID = 1;
    END IF;

    SET Var_NombreRep := CONVERT(CONCAT(Var_NombreRep,Punto,ClaveOrgSup),CHAR(30));
    SELECT Var_NombreRep AS nombreArchivo;
END IF;

END TerminaStore$$