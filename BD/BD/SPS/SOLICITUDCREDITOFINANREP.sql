-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLICITUDCREDITOFINANREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOLICITUDCREDITOFINANREP`;
DELIMITER $$


CREATE PROCEDURE `SOLICITUDCREDITOFINANREP`(
/* SP DE REPORTE PARA LA SOLICITUD DE CREDITO DE LA FINANCIERA CONFIABLE */
	Par_SoliCredID      BIGINT(20),   -- Numero de la Solicitud de Credito
    Par_TipoReporte     INT(11),            -- Tipo o Seccion del Reporte de Solicitud de Credito.

  /* Parametros de Auditoria */
    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)

    )

TerminaStore: BEGIN

/* Declaracion de Variables */
DECLARE Var_NombrePromotor    VARCHAR(200);
DECLARE Var_SolCreditoID      BIGINT;
DECLARE Var_ClienteID         BIGINT;
DECLARE Var_ProspectoID       BIGINT;
DECLARE Var_SucursalID        INT;
DECLARE Var_Numcliente        BIGINT;
DECLARE Var_NombreSucurs      VARCHAR(200);
DECLARE Var_NombreCli         VARCHAR(200);
DECLARE Var_FecNacCli         DATE;
DECLARE Var_PaisNac           VARCHAR(200);
DECLARE Var_EstadoNac         VARCHAR(200);
DECLARE Var_CliSexo           CHAR(1);
DECLARE Var_CliGenero         VARCHAR(20);
DECLARE Var_Ocupacion         VARCHAR(1000);
DECLARE Var_ClaveNacion       CHAR(1);
DECLARE Var_CliNacion         VARCHAR(50);
DECLARE Var_ClaveEstCiv       CHAR(2);
DECLARE Var_DescriEstCiv      VARCHAR(50);
DECLARE Var_CliCURP           VARCHAR(20);
DECLARE Var_CliRFC            VARCHAR(20);
DECLARE Var_EscoCli           VARCHAR(100);
DECLARE Var_CliCalle          VARCHAR(200);
DECLARE Var_CliNumInt         VARCHAR(20);
DECLARE Var_CliPiso           VARCHAR(20);
DECLARE Var_CliLote           VARCHAR(20);
DECLARE Var_CliManzana        VARCHAR(100);
DECLARE Var_CliColoni         VARCHAR(400);
DECLARE Var_CliNumCasa        VARCHAR(20);
DECLARE Var_CliMunici         VARCHAR(200);
DECLARE Var_CliColMun         VARCHAR(300);
DECLARE Var_CliCalNum         VARCHAR(300);
DECLARE Var_1aEntreCalle      VARCHAR(200);
DECLARE Var_2aEntreCalle      VARCHAR(200);
DECLARE Var_CliTelTra         VARCHAR(100);
DECLARE Var_CliTelCel         VARCHAR(20);
DECLARE Var_CliTelPart        VARCHAR(20);
DECLARE Var_CliValorViv       DECIMAL(12,2);
DECLARE Var_CliTipViv         VARCHAR(100);
DECLARE Var_CliMatViv         VARCHAR(100);
DECLARE Var_DirTrabajo        VARCHAR(500);
DECLARE Var_CliLugTra         VARCHAR(200);
DECLARE Var_CliPuesto         VARCHAR(100);
DECLARE Var_CliAntTra         DECIMAL(12,2);
DECLARE Var_DesCliAntTra      VARCHAR(100);
DECLARE Var_MontoSolici       DECIMAL(14,2);
DECLARE Var_Finalidad         VARCHAR(500);
DECLARE Var_Tasa              DECIMAL(14,2);
DECLARE Var_DesProducto       VARCHAR(200);
DECLARE Var_Plazo             VARCHAR(100);
DECLARE Var_Moneda            VARCHAR(80);
DECLARE Var_Destino           VARCHAR(300);
DECLARE Var_Frecuencia        VARCHAR(50);
DECLARE Var_TipoGarant        VARCHAR(50);
DECLARE Var_ConyPriNom        VARCHAR(100);           -- Datos del Conyugue
DECLARE Var_ConySegNom        VARCHAR(100);
DECLARE Var_ConyTerNom        VARCHAR(100);
DECLARE Var_ConyApePat        VARCHAR(100);
DECLARE Var_ConyApeMat        VARCHAR(100);
DECLARE Var_ConyFecNac        DATE;
DECLARE Var_ConyPaiNac        VARCHAR(100);
DECLARE Var_ConyEstNac        VARCHAR(100);
DECLARE Var_ConyNomEmp        VARCHAR(200);
DECLARE Var_ConyEstEmp        VARCHAR(100);
DECLARE Var_ConyMunEmp        VARCHAR(150);
DECLARE Var_ConyColEmp        VARCHAR(200);
DECLARE Var_ConyCalEmp        VARCHAR(200);
DECLARE Var_ConyNumExt        VARCHAR(20);
DECLARE Var_ConyNumInt        VARCHAR(20);
DECLARE Var_ConyNumPiso       VARCHAR(20);
DECLARE Var_ConyCodPos        VARCHAR(5);
DECLARE Var_ConyAntAnio       VARCHAR(20);
DECLARE Var_ConyAntMes        VARCHAR(20);
DECLARE Var_ConyTelTra        VARCHAR(20);
DECLARE Var_ConyTelCel        VARCHAR(20);
DECLARE Var_ConyNomCom        VARCHAR(300);
DECLARE Var_DirEmpCony        VARCHAR(300);
DECLARE Var_ConyAntTra        VARCHAR(100);
DECLARE Var_ConyOcupa         VARCHAR(350);
DECLARE Var_ConyNacion        VARCHAR(50);
DECLARE Var_ProducCredID      INT;
DECLARE Var_ClienteEdad       INT;
DECLARE Var_ConyugeEdad       INT;
DECLARE Var_NumCreditos       INT;
DECLARE Var_CicBaseCli        INT;
DECLARE Var_ClienteCiclo      INT;
DECLARE Var_NumCreTra         INT;
DECLARE Var_MonUltCred        DECIMAL(14,2);
DECLARE Var_NumDepend         INT;
DECLARE Var_NumHijos          INT;
DECLARE Fecha_Sis             DATE;
DECLARE Var_DirTra            VARCHAR(300);
DECLARE Var_NombreSucur       VARCHAR(100);
DECLARE Var_NombreInstitucion 	VARCHAR(100);
DECLARE	Var_DirecSucursal		VARCHAR(300);
DECLARE Var_DirecCompletSuc		VARCHAR(900);
DECLARE Var_CliCorreo           VARCHAR(50);
DECLARE Var_UsuAltaSol          VARCHAR(200);
DECLARE Var_IDUsuAltaSol        INT(11);
DECLARE Var_TipoIdentifi        VARCHAR(45);
DECLARE Var_NumIdentifi         VARCHAR(30);
DECLARE Var_TipoVivienda        VARCHAR(50);
DECLARE Var_ValorVivienda       DECIMAL(18,2);
DECLARE Var_TiempoHabVivienda   INT(11);
DECLARE Var_IDTipoVivienda      INT(11);
DECLARE Var_CPCliente           CHAR(5);
DECLARE Var_PuestoCli           VARCHAR(100);
DECLARE Var_obserVivienda       VARCHAR(500);
DECLARE Var_AutoriIdentiID      INT(11);
DECLARE Var_MontoMaxRetAbo      DECIMAL(16,2);
DECLARE Var_OrigenRecurs        VARCHAR(45);
DECLARE Var_DestinoRecurs       VARCHAR(45);
DECLARE Var_TipoDispersion      VARCHAR(15); 
DECLARE Var_EsProveedorRecurs   CHAR(1);
DECLARE Var_NomProvRecurs       VARCHAR(200);
DECLARE Var_CliObserva          VARCHAR(500);
DECLARE Var_RecursoProvTer      CHAR(2);
DECLARE Var_DescrVivienda       VARCHAR(500);
DECLARE Var_CadTiempHabitVivien VARCHAR(20);
DECLARE Var_TrabajoObserv       VARCHAR(500);
DECLARE Var_CPTrabajo           CHAR(5);




/* Declaracion de Constantes */
DECLARE Fecha_Vacia         	DATE;
DECLARE Decimal_Cero        	DECIMAL(12,2);
DECLARE Entero_Cero         	INT;
DECLARE Cadena_Vacia        	CHAR(1);
DECLARE Seccion_General     	INT;
DECLARE Si_Requiere         	CHAR(1);
DECLARE Est_Vigente         	CHAR(1);
DECLARE Rel_Hijo            	INT;
DECLARE Est_Pagado          	CHAR(1);
DECLARE Gen_Masculino       	CHAR(1);
DECLARE Gen_Femenino        	CHAR(1);


DECLARE Des_Masculino       	VARCHAR(20);
DECLARE Des_Femenino        	VARCHAR(20);
DECLARE Nac_Mexicano        	CHAR(1);
DECLARE Nac_Extranjero      	CHAR(1);
DECLARE Des_Mexicano        	VARCHAR(20);
DECLARE Des_Extranjero      	VARCHAR(20);
DECLARE Est_Soltero         	CHAR(2);
DECLARE Est_CasBieSep       	CHAR(2);
DECLARE Est_CasBieMan       	CHAR(2);
DECLARE Est_CasCapitu       	CHAR(2);
DECLARE Est_Viudo           	CHAR(2);
DECLARE Est_Divorciad       	CHAR(2);
DECLARE Est_Seperados       	CHAR(2);
DECLARE Est_UnionLibre      	CHAR(2);
DECLARE Dir_Oficial         	CHAR(1);
DECLARE Dir_Trabajo         	INT;
DECLARE Des_Soltero         	CHAR(50);
DECLARE Des_CasBieSep       	CHAR(50);
DECLARE Des_CasBieMan       	CHAR(50);
DECLARE Des_CasCapitu       	CHAR(50);
DECLARE Des_Viudo           	CHAR(50);
DECLARE Des_Divorciad       	CHAR(50);
DECLARE Des_Seperados       	CHAR(50);
DECLARE Des_UnionLibre      	CHAR(50);
DECLARE TipoDirTrab         	INT;
DECLARE SI                  	CHAR(1);
DECLARE Var_SI          		CHAR(1);
DECLARE Var_NO          		CHAR(1);
DECLARE Es_Cliente          	CHAR(1);
DECLARE Cheque                  CHAR(1);
DECLARE Spei                    CHAR(1);
DECLARE OrdenPag                CHAR(1);
DECLARE Var_CuentaAhoId         BIGINT(12);
DECLARE Var_ApellidoPatProv   VARCHAR(50);    
DECLARE Var_ApellidoMatProv   VARCHAR(50);
DECLARE Var_RfcProv           CHAR(13);
DECLARE Var_NacionProv        CHAR(1);
DECLARE Var_FechaNacProv      DATE;
DECLARE Var_DomicilioProv     VARCHAR(200);
DECLARE Var_Peps              CHAR(1);
DECLARE Var_ParentPep         CHAR(1);




--  Declaracion de constante

DECLARE FrecSemanal       	CHAR;
DECLARE FrecCatorcenal      CHAR;
DECLARE FrecLibre       	CHAR;
DECLARE FrecQuincenal     	CHAR;
DECLARE FrecMensual       	CHAR;
DECLARE FrecPeriodica     	CHAR;
DECLARE FrecBimestral     	CHAR;
DECLARE FrecTrimestral      CHAR;
DECLARE FrecTetramestral	CHAR;
DECLARE FrecSemestral     	CHAR;
DECLARE FrecAnual       	CHAR;
DECLARE FrecUnico       	CHAR;
DECLARE FrecDecenal       	CHAR;
DECLARE TxtSemanal        	VARCHAR(20);
DECLARE TxtCatorcenal     	VARCHAR(20);
DECLARE TxtQuincenal      	VARCHAR(20);
DECLARE TxtMensual        	VARCHAR(20);
DECLARE TxtPeriodica      	VARCHAR(20);
DECLARE TxtBimestral      	VARCHAR(20);
DECLARE TxtTrimestral     	VARCHAR(20);
DECLARE TxtTetramestral		VARCHAR(20);
DECLARE TxtSemestral      	VARCHAR(20);
DECLARE TxtAnual        	VARCHAR(20);
DECLARE TxtUnico        	VARCHAR(40);
DECLARE Var_CalcAntiguedad    	CHAR(1);
DECLARE Var_RutaFirma      VARCHAR(400);
DECLARE Var_DocuFirmaSolID  INT(11);
DECLARE Var_CliArchID		INT(11);



-- Asigancion de Constantes
SET Fecha_Vacia         := '1900-01-01';            -- Fecha Vacia
SET Decimal_Cero        := 0.0;                     -- Decimal en Cero
SET Entero_Cero         := 0;                       -- Entero en Cero
SET Cadena_Vacia        := '';                      -- String o Cadena Vacia
SET Seccion_General     := 1;                       -- Seccion Gral, Cliente, Solicitud
SET Si_Requiere         := 'S';                     -- Si Rquiere Garantia
SET Gen_Masculino       := 'M';                     -- Genero: Masculino
SET Gen_Femenino        := 'F';                     -- Genero: Femenino
SET Des_Masculino       := 'MASCULINO';             -- Descripcion Genero: Masculino
SET Des_Femenino        := 'FEMENINO';              -- Descripcion Genero: Femenino
SET Nac_Mexicano        := 'N';           -- Nacionalidad: N.- Nacional - Mexicano
SET Nac_Extranjero      := 'E';                     -- Nacionalidad: E.- Nacional - Extranjero
SET Des_Mexicano        := 'MEXICANA';              -- Nacionalidad: Mexicana
SET Des_Extranjero      := 'EXTRANJERA';            -- Nacionalidad: Extranjera
SET Est_Vigente         := 'V';                     -- Estatus del Credito Vigente
SET Est_Pagado          := 'P';                     -- Estatus del Credito Pagado
SET Est_Soltero       := 'S';        -- Estado Civil Soltero
SET Est_CasBieSep     := 'CS';       -- Casado Bienes Separados
SET Est_CasBieMan     := 'CM';       -- Casado Bienes Mancomunados
SET Est_CasCapitu     := 'CC';       -- Casado Bienes Mancomunados Con Capitulacion
SET Est_Viudo         := 'V';        -- Viudo
SET Est_Divorciad     := 'D';        -- Divorciado
SET Est_Seperados     :='SE';        -- Separado
SET Est_UnionLibre    := 'U';        -- Union Libre
SET Dir_Oficial       := 'S';         -- Tipo de Direccion: Oficial
SET Dir_Trabajo       := 3;           -- Tipo de Direccion: Trabajo


SET Des_Soltero       := 'SOLTERO(A)';                    -- Descripcion para el estado civil de un cliente
SET Des_CasBieSep     := 'CASADO(A) BIENES SEPARADOS';            -- Descripcion para el estado civil de un cliente
SET Des_CasBieMan     := 'CASADO(A) BIENES MANCOMUNADOS';           -- Descripcion para el estado civil de un cliente
SET Des_CasCapitu     := 'CASADO(A) BIENES MANCOMUNADOS CON CAPITULACION';  -- Descripcion para el estado civil de un cliente
SET Des_Viudo         := 'VIUDO(A)';                      -- Descripcion para el estado civil de un cliente
SET Des_Divorciad     := 'DIVORCIADO(A)';                   -- Descripcion para el estado civil de un cliente
SET Des_Seperados     := 'SEPARADO(A)';                   -- Descripcion para el estado civil de un cliente
SET Des_UnionLibre    := 'UNION LIBRE';                   -- Descripcion para el estado civil de un cliente
SET SI                := 'S';                         -- Constante Si
SET Var_SI        	  := 'S';                         -- Constante SI
SET Var_NO        	  := 'N';                         -- Constante No


SET FrecSemanal     	:= 'S';
SET FrecCatorcenal    	:= 'C';
SET FrecQuincenal   	:= 'Q';
SET FrecMensual     	:= 'M';
SET FrecPeriodica   	:= 'P';
SET FrecBimestral   	:= 'B';
SET FrecTrimestral    	:= 'T';
SET FrecTetramestral	:= 'R';
SET FrecSemestral   	:= 'E';
SET FrecAnual     		:= 'A';
SET FrecUnico     		:= 'U';


SET TxtSemanal      	:= 'semanal' ;
SET TxtCatorcenal   	:= 'catorcenal' ;
SET TxtQuincenal    	:= 'quincenal' ;
SET TxtMensual      	:= 'mensual' ;
SET TxtPeriodica    	:= 'periodica'   ;
SET TxtBimestral    	:= 'bimestral' ;
SET TxtTrimestral   	:= 'trimestral' ;
SET TxtTetramestral		:= 'tetramestral' ;
SET TxtSemestral    	:= 'semestral';
SET TxtAnual      		:= 'anual';
SET TxtUnico        	:= 'PAGO UNICO';
SET Spei                := 'S';
SET Cheque              := 'C';
SET OrdenPag            := 'O';

SET Var_CalcAntiguedad := IFNULL((SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = 'DetLaboralCteConyug'), Var_NO);

SET Fecha_Sis:= (SELECT FechaSistema  FROM PARAMETROSSIS  WHERE EmpresaID=1);

SET Var_DocuFirmaSolID  := 73;


IF(Par_TipoReporte = Seccion_General) THEN

    SELECT  Sol.SolicitudCreditoID, Sol.ClienteID,      Sol.ProspectoID,    Sol.SucursalID,     Sol.ProductoCreditoID,
            Sol.MontoSolici,    Sol.Proyecto,       Sol.TasaFija,       Pro.Descripcion,
            Crp.Descripcion,    Mon.Descripcion,    Des.Descripcion, Sol.UsuarioAltaSol,
            CASE Sol.TipoDispersion
            WHEN  Cheque   THEN 'CHEQUE' 
            WHEN  Spei     THEN 'SPEI'
            WHEN  OrdenPag THEN 'ORDEN PAGO'
            END,
            CASE WHEN IFNULL(Sol.PorcGarLiq, Entero_Cero) != Entero_Cero THEN
                    CONCAT("LIQUIDA ", FORMAT(Sol.PorcGarLiq,2), "%")
                 WHEN IFNULL(Pro.RequiereGarantia, Cadena_Vacia) = Si_Requiere THEN
                    "MOBILIARIA, INMOBILIARIA"
            END,
            CASE Sol.FrecuenciaCap
                WHEN FrecSemanal    THEN UPPER(TxtSemanal)
                WHEN FrecCatorcenal   THEN UPPER(TxtCatorcenal)
                WHEN FrecQuincenal    THEN UPPER(TxtQuincenal)
                WHEN FrecMensual    THEN UPPER(TxtMensual)
                WHEN FrecPeriodica    THEN UPPER(TxtPeriodica)
                WHEN FrecBimestral    THEN UPPER(TxtBimestral)
                WHEN FrecTrimestral   THEN UPPER(TxtTrimestral)
                WHEN FrecTetramestral   THEN UPPER(TxtTetramestral)
                WHEN FrecSemestral    THEN UPPER(TxtSemestral)
                WHEN FrecAnual      THEN UPPER(TxtAnual)
        WHEN FrecUnico      THEN UPPER(TxtUnico)
            END


            INTO
            Var_SolCreditoID,   Var_ClienteID,      Var_ProspectoID,    Var_SucursalID, Var_ProducCredID,
            Var_MontoSolici,    Var_Finalidad,      Var_Tasa,       Var_DesProducto,
            Var_Plazo,          Var_Moneda,         Var_Destino,    Var_IDUsuAltaSol,  Var_TipoDispersion,
            Var_TipoGarant,
            Var_Frecuencia
        FROM SOLICITUDCREDITO Sol,
             MONEDAS Mon,
             PRODUCTOSCREDITO Pro,
             CREDITOSPLAZOS Crp,
             DESTINOSCREDITO Des
        WHERE Sol.SolicitudCreditoID = Par_SoliCredID
          AND Sol.MonedaID = Mon.MonedaId
          AND Sol.PlazoID = Crp.PlazoID
          AND Sol.DestinoCreID = Des.DestinoCreID
          AND Sol.ProductoCreditoID = Pro.ProducCreditoID
    LIMIT 1;

  SET Var_SolCreditoID   := IFNULL(Var_SolCreditoID, Entero_Cero);
    SET Var_ClienteID   := IFNULL(Var_ClienteID, Entero_Cero);
    SET Var_ProspectoID := IFNULL(Var_ProspectoID, Entero_Cero);
    SET Var_ProducCredID := IFNULL(Var_ProducCredID, Entero_Cero);

-- ---------------------------------------------------------------------------------
-- SE EVALUA SI LA CONSULTA SE HARA SOBRE UN CLIENTE O PROSPECTO
-- ---------------------------------------------------------------------------------
  IF(Var_ClienteID != Entero_Cero)THEN
    SET Es_Cliente = Var_SI;
  ELSE
    SET Es_Cliente = Var_NO;
  END IF;


    IF(Var_ClienteID != Entero_Cero) THEN           -- Es Cliente
        SET Var_Numcliente  := Var_ClienteID;

        -- Generales del Cliente
        SELECT  Cli.NombreCompleto, Cli.FechaNacimiento,    Pan.Nombre,         Esr.Nombre, Cli.Sexo,
                Ocu.Descripcion,    Cli.Nacion,             Cli.EstadoCivil,    Cli.CURP,   Cli.RFC,
                Cli.TelTrabajo,     Cli.Telefono,           Cli.LugardeTrabajo, Cli.Puesto, Cli.TelefonoCelular,
                Cli.Correo,         Cli.Observaciones,      Cli.Puesto,       
        CASE WHEN Var_CalcAntiguedad = Var_SI THEN  CASE WHEN IFNULL(Cli.FechaIniTrabajo,Fecha_Vacia) = Fecha_Vacia
                                  THEN Entero_Cero
                                 ELSE
                                  ROUND(DATEDIFF(Fecha_Sis,Cli.FechaIniTrabajo) / 365,1)
                              END
           ELSE Cli.AntiguedadTra
        END
                INTO Var_NombreCli, Var_FecNacCli,      Var_PaisNac,        Var_EstadoNac,  Var_CliSexo,
                     Var_Ocupacion, Var_ClaveNacion,    Var_ClaveEstCiv,    Var_CliCURP,    Var_CliRFC,
                     Var_CliTelTra, Var_CliTelPart,     Var_CliLugTra,      Var_CliPuesto,  Var_CliTelCel,
                     Var_CliCorreo, Var_CliObserva,     Var_PuestoCli,      Var_CliAntTra
            FROM CLIENTES Cli
        INNER JOIN PAISES Pan ON Cli.LugarNacimiento = Pan.PaisID
        LEFT OUTER JOIN ESTADOSREPUB Esr ON Cli.EstadoID = Esr.EstadoID
        LEFT OUTER JOIN OCUPACIONES Ocu ON Cli.OcupacionID = Ocu.OcupacionID
          WHERE ClienteID = Var_ClienteID LIMIT 1;
        -- Nombre Promotor
        SELECT  P.NombrePromotor INTO Var_NombrePromotor
        FROM
        SOLICITUDCREDITO  C,
        PROMOTORES  P
      WHERE C.SolicitudCreditoID= Par_SoliCredID
      AND C.PromotorID=P.PromotorID LIMIT 1;
        -- Direccion del Cliente
        SELECT Dir.Calle, Dir.NumInterior, Dir.Piso, Dir.Lote, Dir.Manzana,
               Col.Asentamiento, Dir.NumeroCasa, Mun.Nombre,    Dir.PrimeraEntreCalle,
               Dir.SegundaEntreCalle, Dir.CP
      INTO Var_CliCalle, Var_CliNumInt, Var_CliPiso, Var_CliLote, Var_CliManzana,
         Var_CliColoni, Var_CliNumCasa, Var_CliMunici, Var_1aEntreCalle,
         Var_2aEntreCalle, Var_CPCliente
          FROM DIRECCLIENTE Dir,
             COLONIASREPUB Col,
             MUNICIPIOSREPUB Mun
            WHERE ClienteID = Var_ClienteID
              AND Oficial = Dir_Oficial
              AND Dir.EstadoID = Col.EstadoID
              AND Dir.MunicipioID = Col.MunicipioID
              AND Dir.ColoniaID = Col.ColoniaID
              AND Mun.EstadoID  = Col.EstadoID
              AND Mun.MunicipioID = Col.MunicipioID
              LIMIT 1;

        -- Direccion del Trabajo
        SELECT DireccionCompleta, Descripcion, CP 
        INTO Var_DirTrabajo, Var_TrabajoObserv, Var_CPTrabajo
        FROM DIRECCLIENTE Dir
        WHERE ClienteID = Var_ClienteID
          AND TipoDireccionID = Dir_Trabajo
            LIMIT 1;

        -- Numero de Creditos
        SELECT SUM(CASE WHEN Cre.ProductoCreditoID =  Var_ProducCredID AND
                             (Cre.Estatus = Est_Vigente OR Cre.Estatus = Est_Pagado) THEN 1
                        ELSE Entero_Cero
                    END),
               SUM(CASE WHEN Cre.Estatus = Est_Pagado THEN 1
                        ELSE Entero_Cero
                    END)
                INTO Var_NumCreditos, Var_NumCreTra
            FROM CREDITOS Cre
        WHERE Cre.ClienteID         = Var_ClienteID
          LIMIT 1;

        SET Var_NumCreTra   := IFNULL(Var_NumCreTra, Entero_Cero);

        -- Se le suma un uno, por si el cliente no tiene creditos o experiencia con la institucion
        -- Entonces decimos que es su 1er ciclo el credito que esta Solicitando
        SET Var_NumCreditos := IFNULL(Var_NumCreditos, Entero_Cero) + 1;

        -- Monto del Ultimo Credito Pagado
        IF(Var_NumCreTra != Entero_Cero) THEN
            SELECT MontoCredito INTO Var_MonUltCred
                FROM CREDITOS Cre
          WHERE ClienteID = Var_ClienteID
            AND Cre.Estatus = Est_Pagado
              ORDER BY FechaInicio DESC
              LIMIT 1;
        END IF;

        SET Var_MonUltCred  := IFNULL(Var_MonUltCred, Entero_Cero);

    ELSE -- EndIf es Cliente

        -- Es Prospecto
        SET Var_Numcliente  := Var_ProspectoID;

        -- Generales del Prospecto
        SELECT  Cli.NombreCompleto, Cli.FechaNacimiento,    Cli.Sexo,           Cli.EstadoCivil,
                Cli.RFC,            Cli.Telefono,           Cli.Calle,          Cli.NumInterior,
                Cli.Lote,           Cli.Manzana,            Col.Asentamiento,   Cli.NumExterior,
                Mun.Nombre
      INTO
                Var_NombreCli,  Var_FecNacCli,  Var_CliSexo,    Var_ClaveEstCiv,
                Var_CliRFC,     Var_CliTelPart, Var_CliCalle,   Var_CliNumInt,
                Var_CliLote,    Var_CliManzana, Var_CliColoni,  Var_CliNumCasa,
                Var_CliMunici
            FROM PROSPECTOS Cli,
                 COLONIASREPUB Col,
                 MUNICIPIOSREPUB Mun
          WHERE Cli.ProspectoID = Var_ProspectoID
            AND Cli.EstadoID = Col.EstadoID
            AND Cli.MunicipioID = Col.MunicipioID
            AND Cli.ColoniaID = Col.ColoniaID
            AND Mun.EstadoID  = Col.EstadoID
            AND Mun.MunicipioID = Col.MunicipioID
          LIMIT 1;

        SET Var_ClaveNacion := Nac_Mexicano;
        -- Si es prospecto entonces no puede tener creditos actuales, le indicamos es su 1er ciclo
        SET Var_NumCreditos := 1;
        SET Var_MonUltCred  := Entero_Cero;
        SET Var_NumCreTra   := Entero_Cero;

    END IF; -- EndIf es Prospecto

    -- Ciclo Base del Cliente-Prospecto
    SELECT  CicloBase INTO Var_CicBaseCli
        FROM CICLOBASECLIPRO Cib
    WHERE (CASE WHEN IFNULL(Es_Cliente,Cadena_Vacia) = Var_SI THEN Cib.ClienteID = Var_ClienteID
          ELSE Cib.ProspectoID = Var_ProspectoID
        END)
    AND Cib.ProductoCreditoID = Var_ProducCredID;

    SET Var_CicBaseCli := IFNULL(Var_CicBaseCli, Entero_Cero);
    SET Var_ClienteCiclo := Var_NumCreditos + Var_CicBaseCli;

    SET Var_CliSexo := IFNULL(Var_CliSexo, Cadena_Vacia);

    IF(Var_CliSexo = Gen_Masculino) THEN
        SET Var_CliGenero   := Des_Masculino;
    ELSE
        SET Var_CliGenero   := Des_Femenino;
    END IF;

    IF (Var_ClaveNacion = Nac_Mexicano) THEN
        SET Var_CliNacion   := Des_Mexicano;
    ELSE
        SET Var_CliNacion   := Des_Extranjero;
    END IF;

  IF (Var_ClaveNacion = Nac_Extranjero) THEN
        SET Var_CliNacion   := Des_Extranjero;
    ELSE
        SET Var_CliNacion   := Des_Mexicano;
    END IF;

    SET Var_DescriEstCiv    := (SELECT CASE Var_ClaveEstCiv
                                    WHEN Est_Soltero  THEN Des_Soltero
                                    WHEN Est_CasBieSep  THEN Des_CasBieSep
                                    WHEN Est_CasBieMan  THEN Des_CasBieMan
                                    WHEN Est_CasCapitu  THEN Des_CasCapitu
                                    WHEN Est_Viudo  THEN Des_Viudo
                                    WHEN Est_Divorciad  THEN Des_Divorciad
                                    WHEN Est_Seperados  THEN Des_Seperados
                                    WHEN Est_UnionLibre  THEN Des_UnionLibre
                                    ELSE Cadena_Vacia
                                END );

    -- Cliente - Prospecto
    SELECT Esc.Descripcion INTO Var_EscoCli
        FROM SOCIODEMOGRAL Soc,
             CATGRADOESCOLAR Esc
    WHERE (CASE WHEN IFNULL(Es_Cliente,Cadena_Vacia) = Var_SI THEN Soc.ClienteID = Var_ClienteID
            ELSE Soc.ProspectoID = Var_ProspectoID
          END)
          AND Soc.GradoEscolarID = Esc.GradoEscolarID;

    SET Var_EscoCli := IFNULL(Var_EscoCli, Cadena_Vacia);

    SET Var_CliCalle      := IFNULL(Var_CliCalle, Cadena_Vacia);
    SET Var_CliNumInt     := IFNULL(Var_CliNumInt, Cadena_Vacia);
    SET Var_CliPiso       := IFNULL(Var_CliPiso, Cadena_Vacia);
    SET Var_CliLote       := IFNULL(Var_CliLote, Cadena_Vacia);
    SET Var_CliManzana    := IFNULL(Var_CliManzana, Cadena_Vacia);
    SET Var_CliColoni     := IFNULL(Var_CliColoni, Cadena_Vacia);
    SET Var_CliNumCasa    := IFNULL(Var_CliNumCasa, Cadena_Vacia);
    SET Var_CliMunici     := IFNULL(Var_CliMunici, Cadena_Vacia);
    SET Var_1aEntreCalle  := IFNULL(Var_1aEntreCalle, Cadena_Vacia);
    SET Var_2aEntreCalle  := IFNULL(Var_2aEntreCalle, Cadena_Vacia);
    SET Var_CliTelTra     := IFNULL(Var_CliTelTra, Cadena_Vacia);
    SET Var_CliTelCel     := IFNULL(Var_CliTelCel, Cadena_Vacia);
    SET Var_CliCorreo     := IFNULL(Var_CliCorreo, Cadena_Vacia);
    SET Var_CliObserva    := IFNULL(Var_CliObserva, Cadena_Vacia);
    SET Var_CliTelPart    := IFNULL(Var_CliTelPart, Cadena_Vacia);
    SET Var_CliLugTra     := IFNULL(Var_CliLugTra, Cadena_Vacia);
    SET Var_CliPuesto     := IFNULL(Var_CliPuesto, Cadena_Vacia);
    SET Var_CliAntTra     := IFNULL(Var_CliAntTra, Entero_Cero);

    SET Var_CliCalNum   := Var_CliCalle;

    IF(Var_CliNumCasa != Cadena_Vacia) THEN
        SET Var_CliCalNum   := CONCAT(Var_CliCalNum, ' No. ', Var_CliNumCasa);
    END IF;

    IF(Var_CliNumInt != Cadena_Vacia) THEN
        SET Var_CliCalNum   := CONCAT(Var_CliCalNum, ' INTERIOR ', Var_CliNumInt);
    END IF;

    IF(Var_CliLote != Cadena_Vacia) THEN
        SET Var_CliCalNum   := CONCAT(Var_CliCalNum, ' LOTE ', Var_CliLote);
    END IF;

    IF(Var_CliManzana != Cadena_Vacia) THEN
        SET Var_CliCalNum   := CONCAT(Var_CliCalNum, ' MANZANA ', Var_CliManzana);
    END IF;

    IF(Var_CliPiso != Cadena_Vacia) THEN
        SET Var_CliCalNum   := CONCAT(Var_CliCalNum, ' PISO ', Var_CliPiso);
    END IF;

    SET Var_CliColMun   := CONCAT(Var_CliColoni, ',', Var_CliMunici);

    SELECT ValorVivienda, Tiv.Descripcion, Tim.Descripcion, Sov.Descripcion
    INTO
           Var_CliValorViv, Var_CliTipViv, Var_CliMatViv, Var_obserVivienda
        FROM SOCIODEMOVIVIEN Sov,
             TIPOVIVIENDA Tiv,
             TIPOMATERIALVIV Tim
      WHERE (CASE WHEN IFNULL(Es_Cliente,Cadena_Vacia) = Var_SI THEN Sov.ClienteID = Var_ClienteID
              ELSE Sov.ProspectoID = Var_ProspectoID
            END)
          AND Sov.TipoViviendaID = Tiv.TipoViviendaID
          AND Sov.TipoMaterialID = Tim.TipoMaterialID
      LIMIT 1;

    SET Var_CliValorViv := IFNULL(Var_CliValorViv, Entero_Cero);
    SET Var_CliTipViv   := IFNULL(Var_CliTipViv, Cadena_Vacia);
    SET Var_CliMatViv   := IFNULL(Var_CliMatViv, Cadena_Vacia);

    SET Var_DirTrabajo      := IFNULL(Var_DirTrabajo, Cadena_Vacia);
    SET Var_DesCliAntTra    := FORMAT(IFNULL(Var_CliAntTra, Entero_Cero), 2);

    -- Datos del Conyugue

  IF(Var_ClaveEstCiv = Est_CasBieSep OR Var_ClaveEstCiv = Est_CasBieMan OR Var_ClaveEstCiv = Est_CasCapitu OR Var_ClaveEstCiv = Est_UnionLibre )THEN
      SELECT  Coy.PrimerNombre,       Coy.SegundoNombre,      Coy.TercerNombre,       Coy.ApellidoPaterno,
          Coy.ApellidoMaterno,    Coy.FechaNacimiento,    Pan.Nombre,             Esr.Nombre,
          Coy.EmpresaLabora,      Est.Nombre,             Mun.Nombre,             Coy.Colonia,
          Coy.Calle,              Coy.NumeroExterior,     Coy.NumeroInterior,     Coy.NumeroPiso,
          Coy.CodigoPostal,
          CASE WHEN Var_CalcAntiguedad = Var_SI THEN  CASE WHEN IFNULL(Coy.FechaIniTrabajo,Fecha_Vacia) = Fecha_Vacia
                                  THEN Entero_Cero
                                 ELSE
                                  ROUND(DATEDIFF(Fecha_Sis,Coy.FechaIniTrabajo) / 365)
                              END
           ELSE Coy.AntiguedadAnios
          END,
          CASE WHEN Var_CalcAntiguedad = Var_SI THEN Entero_Cero
                                     ELSE IF(IFNULL(Coy.AntiguedadMeses,Cadena_Vacia)=Cadena_Vacia,Entero_Cero,Coy.AntiguedadMeses)
          END,
          TelefonoTrabajo,
          TelCelular,             Ocu.Descripcion,
          CASE WHEN Coy.Nacionalidad = Nac_Mexicano THEN Des_Mexicano
             ELSE Des_Extranjero
          END
          INTO
          Var_ConyPriNom,         Var_ConySegNom,         Var_ConyTerNom,         Var_ConyApePat,
          Var_ConyApeMat,         Var_ConyFecNac,         Var_ConyPaiNac,         Var_ConyEstNac,
          Var_ConyNomEmp,         Var_ConyEstEmp,         Var_ConyMunEmp,         Var_ConyColEmp,
          Var_ConyCalEmp,         Var_ConyNumExt,         Var_ConyNumInt,         Var_ConyNumPiso,
          Var_ConyCodPos,         Var_ConyAntAnio,        Var_ConyAntMes,         Var_ConyTelTra,
          Var_ConyTelCel,         Var_ConyOcupa,          Var_ConyNacion
      FROM SOCIODEMOCONYUG Coy
      LEFT OUTER JOIN PAISES Pan ON Coy.PaisNacimiento = Pan.PaisID
      LEFT OUTER JOIN ESTADOSREPUB Esr ON Coy.EstadoNacimiento = Esr.EstadoID
      LEFT OUTER JOIN ESTADOSREPUB Est ON Coy.EntidadFedTrabajo = Est.EstadoID
      LEFT OUTER JOIN MUNICIPIOSREPUB Mun ON Coy.EntidadFedTrabajo = Mun.EstadoID AND Coy.MunicipioTrabajo  = Mun.MunicipioID
      LEFT OUTER JOIN OCUPACIONES Ocu ON Coy.OcupacionID = Ocu.OcupacionID
      WHERE (CASE WHEN IFNULL(Es_Cliente,Cadena_Vacia) = Var_SI THEN Coy.ClienteID = Var_ClienteID
            ELSE Coy.ProspectoID = Var_ProspectoID
          END);

  END IF;

    -- Total de Dependientes Economicos y Cuantos son Hijos
    SELECT SUM(1),
           SUM(CASE WHEN Dep.TipoRelacionID = Rel_Hijo THEN 1
                        ELSE Entero_Cero
                    END)
                INTO Var_NumDepend, Var_NumHijos
            FROM SOCIODEMODEPEND Dep
            WHERE (CASE WHEN IFNULL(Es_Cliente,Cadena_Vacia) = Var_SI THEN Dep.ClienteID = Var_ClienteID
          ELSE Dep.ProspectoID = Var_ProspectoID
        END)
      LIMIT 1;

    SET Var_ClienteEdad := FLOOR(DATEDIFF(CURDATE(), Var_FecNacCli) / 365);
    SET Var_ConyugeEdad := FLOOR(DATEDIFF(CURDATE(), Var_ConyFecNac) / 365);

    SELECT NombreSucurs INTO Var_NombreSucurs
        FROM SUCURSALES
        WHERE SucursalID = Var_SucursalID
  LIMIT 1;

    SET Var_NombreSucurs := IFNULL(Var_NombreSucurs, Cadena_Vacia);

    SET Var_ConyPriNom      := IFNULL(Var_ConyPriNom, Cadena_Vacia);
    SET Var_ConySegNom      := IFNULL(Var_ConySegNom, Cadena_Vacia);
    SET Var_ConyTerNom      := IFNULL(Var_ConyTerNom, Cadena_Vacia);
    SET Var_ConyApePat      := IFNULL(Var_ConyApePat, Cadena_Vacia);
    SET Var_ConyApeMat      := IFNULL(Var_ConyApeMat, Cadena_Vacia);
    SET Var_ConyFecNac      := IFNULL(Var_ConyFecNac, Fecha_Vacia);
    SET Var_ConyPaiNac      := IFNULL(Var_ConyPaiNac, Cadena_Vacia);
    SET Var_ConyEstNac      := IFNULL(Var_ConyEstNac, Cadena_Vacia);
    SET Var_ConyNomEmp      := IFNULL(Var_ConyNomEmp, Cadena_Vacia);
    SET Var_ConyEstEmp      := IFNULL(Var_ConyEstEmp, Cadena_Vacia);
    SET Var_ConyMunEmp      := IFNULL(Var_ConyMunEmp, Cadena_Vacia);
    SET Var_ConyColEmp      := IFNULL(Var_ConyColEmp, Cadena_Vacia);
    SET Var_ConyCalEmp      := IFNULL(Var_ConyCalEmp, Cadena_Vacia);
    SET Var_ConyNumExt      := IFNULL(Var_ConyNumExt, Entero_Cero);
    SET Var_ConyNumInt      := IFNULL(Var_ConyNumInt, Cadena_Vacia);
    SET Var_ConyNumPiso     := IFNULL(Var_ConyNumPiso, Cadena_Vacia);
    SET Var_ConyCodPos      := IFNULL(Var_ConyCodPos, Cadena_Vacia);
    SET Var_ConyAntAnio     := IFNULL(Var_ConyAntAnio, Cadena_Vacia);
    SET Var_ConyAntMes      := IFNULL(Var_ConyAntMes, Entero_Cero);
    SET Var_ConyTelTra      := IFNULL(Var_ConyTelTra, Cadena_Vacia);
    SET Var_ConyTelCel      := IFNULL(Var_ConyTelCel, Cadena_Vacia);
    SET Var_ConyOcupa       := IFNULL(Var_ConyOcupa, Cadena_Vacia);
    SET Var_ConyNacion      := IFNULL(Var_ConyNacion, Cadena_Vacia);
    SET Var_ConyugeEdad     := IFNULL(Var_ConyugeEdad, Entero_Cero);
    SET Var_PaisNac         := IFNULL(Var_PaisNac, Cadena_Vacia);
    SET Var_EstadoNac       := IFNULL(Var_EstadoNac, Cadena_Vacia);
    SET Var_CliCURP         := IFNULL(Var_CliCURP, Cadena_Vacia);
    SET Var_Ocupacion       := IFNULL(Var_Ocupacion, Cadena_Vacia);
    SET Var_NumDepend       := IFNULL(Var_NumDepend, Entero_Cero);
    SET Var_NumHijos        := IFNULL(Var_NumHijos, Entero_Cero);

    SET Var_ConyNomCom  := Var_ConyPriNom;

    IF(Var_ConySegNom != Cadena_Vacia) THEN
        SET Var_ConyNomCom  := CONCAT(Var_ConyNomCom, " ", Var_ConySegNom);
    END IF;

    IF(Var_ConyTerNom != Cadena_Vacia) THEN
        SET Var_ConyNomCom  := CONCAT(Var_ConyNomCom, " ", Var_ConyTerNom);
    END IF;

    SET Var_ConyNomCom  := CONCAT(Var_ConyNomCom, " ", Var_ConyApePat, " ", Var_ConyApeMat);

    SET Var_DirEmpCony  := Var_ConyCalEmp;

    IF(Var_ConyNumExt != Entero_Cero) THEN
        SET Var_DirEmpCony  := CONCAT(Var_DirEmpCony, " No ", CONVERT(Var_ConyNumExt, CHAR));
    END IF;

    IF(Var_ConyNumInt != Cadena_Vacia) THEN
        SET Var_DirEmpCony  := CONCAT(Var_DirEmpCony, " Interior ", Var_ConyNumInt);
    END IF;

    IF(Var_ConyNumPiso != Cadena_Vacia) THEN
        SET Var_DirEmpCony  := CONCAT(Var_DirEmpCony, " Piso ", Var_ConyNumPiso);
    END IF;

    IF(Var_ConyNumInt != Cadena_Vacia) THEN
        SET Var_DirEmpCony  := CONCAT(Var_DirEmpCony, " Col. ", Var_ConyColEmp);
    END IF;

    IF(Var_ConyEstEmp != Cadena_Vacia) THEN
        SET Var_DirEmpCony  := CONCAT(Var_DirEmpCony, ", ", Var_ConyEstEmp);
    END IF;

    IF(Var_ConyMunEmp != Cadena_Vacia) THEN
        SET Var_DirEmpCony  := CONCAT(Var_DirEmpCony, ", ", Var_ConyMunEmp);
    END IF;

    IF(Var_ConyMunEmp != Cadena_Vacia) THEN
        SET Var_DirEmpCony  := CONCAT(Var_DirEmpCony, ", CP ", Var_ConyCodPos);
    END IF;

    SET Var_ConyAntTra  := Cadena_Vacia;

    IF(Var_ConyAntAnio != Cadena_Vacia) THEN
        SET Var_ConyAntTra  := CONCAT(CONVERT(Var_ConyAntAnio, CHAR), " Año(s) ");

        IF(Var_ConyAntMes != Entero_Cero) THEN
            SET Var_ConyAntTra  := CONCAT(Var_ConyAntTra, " y ", CONVERT(Var_ConyAntMes, CHAR), " Mes(es)");
        END IF;
    ELSE
        IF(Var_ConyAntMes != Entero_Cero) THEN
            SET Var_ConyAntTra  := CONCAT(CONVERT(Var_ConyAntAnio, CHAR), " Mes(es)");
        END IF;
    END IF;
	-- ===================================
	SELECT I.Nombre
	INTO Var_NombreInstitucion
	FROM PARAMETROSSIS Par
	INNER JOIN INSTITUCIONES I ON Par.InstitucionID = I.InstitucionID;

	SELECT CONCAT(Mun.Nombre,', ',Est.Nombre),Suc.DirecCompleta
	INTO Var_DirecSucursal,Var_DirecCompletSuc
	FROM SOLICITUDCREDITO Sol
	INNER JOIN SUCURSALES Suc ON  Sol.SucursalID = Suc.SucursalID
	INNER JOIN ESTADOSREPUB Est ON Suc.EstadoID = Est.EstadoID
	INNER JOIN MUNICIPIOSREPUB Mun ON Suc.EstadoID = Mun.EstadoID
										AND Suc.MunicipioID= Mun.MunicipioID
	WHERE Sol.SolicitudCreditoID = Var_SolCreditoID;
	-- ==================================
    -- Nombre del asesor relacionado a la solicitud de credito(L)
    SET Var_IDUsuAltaSol :=IFNULL(Var_IDUsuAltaSol,Entero_Cero);
    SET Var_UsuAltaSol   :=(SELECT NombreCompleto FROM USUARIOS WHERE UsuarioID=Var_IDUsuAltaSol LIMIT 1 );

    -- Tipo de identificación (L)
    SELECT Descripcion,NumIdentific, TipoIdentiID
    INTO
    Var_TipoIdentifi, Var_NumIdentifi, Var_AutoriIdentiID
    FROM IDENTIFICLIENTE
    WHERE ClienteID=Var_ClienteID LIMIT 1;

    SET Var_TipoIdentifi :=IFNULL(Var_TipoIdentifi,Cadena_Vacia);
    SET Var_NumIdentifi :=IFNULL(Var_NumIdentifi,Cadena_Vacia);

    -- Tipo de vivienda(L)
    SELECT Descripcion,TipoViviendaID,ValorVivienda,TiempoHabitarDom
    INTO 
          Var_DescrVivienda,Var_IDTipoVivienda,Var_ValorVivienda, Var_TiempoHabVivienda
    FROM SOCIODEMOVIVIEN
    WHERE ClienteID=Var_ClienteID;

    SET Var_TiempoHabVivienda:=IFNULL(Var_TiempoHabVivienda,Entero_Cero);
    SET Var_CadTiempHabitVivien:=CONCAT(Var_TiempoHabVivienda,'  MESES');

    SET Var_IDTipoVivienda:=IFNULL(Var_IDTipoVivienda,Entero_Cero);
    SET Var_TipoVivienda  :=(SELECT Descripcion FROM TIPOVIVIENDA WHERE TipoViviendaID=Var_IDTipoVivienda  LIMIT 1);

    -- Monto maximo de deposito y retiro -- Origen y Destino recursos
    SELECT P.DepositosMax, CATD.Descripcion,CATO.Descripcion 
    INTO   Var_MontoMaxRetAbo,Var_DestinoRecurs, Var_OrigenRecurs 
    FROM  PLDPERFILTRANS P
    LEFT  JOIN   CATPLDDESTINOREC CATD ON P.CatDestinoRecID=CATD.CatDestinoRecID
    LEFT  JOIN   CATPLDORIGENREC CATO  ON P.CatOrigenRecID=CATO.CatOrigenRecID
    WHERE   P.ClienteID=Var_ClienteID;

    -- Extraer cuentaAhoID
    SET Var_CuentaAhoId=(
                    SELECT C.CuentaID FROM SOLICITUDCREDITO S 
                    INNER JOIN CREDITOS C  ON S.CreditoID=C.CreditoID
                    WHERE S.ClienteID=Var_ClienteID AND S.SolicitudCreditoID=Par_SoliCredID LIMIT 1);
    SET Var_CuentaAhoId=IFNULL(Var_CuentaAhoId,Entero_Cero);
    -- Recursos Terceros Si-No
    SELECT RecursoProvTer 
    INTO   Var_RecursoProvTer
    FROM CONOCIMIENTOCTA 
    WHERE CuentaAhoID=Var_CuentaAhoId;
    SET Var_RecursoProvTer=IFNULL(Var_RecursoProvTer,Cadena_Vacia);

    IF(Var_RecursoProvTer=Cadena_Vacia) THEN
       SET Var_RecursoProvTer=Var_NO;
    ELSE 
        SET Var_RecursoProvTer=Var_SI;
    END IF;    
    
    -- Datos proveedor recursos
    SET Var_EsProveedorRecurs=(SELECT  EsProvRecurso FROM CUENTASPERSONA WHERE CuentaAhoID=Var_CuentaAhoId LIMIT 1);
    IF(Var_EsProveedorRecurs=Var_SI) THEN
    SELECT NombreCompleto,        ApellidoPaterno,       ApellidoMaterno,       RFC,             Nacionalidad,
           FechaNac,              Domicilio
    INTO   Var_NomProvRecurs,     Var_ApellidoPatProv,   Var_ApellidoMatProv,   Var_RfcProv,     Var_NacionProv,
           Var_FechaNacProv,      Var_DomicilioProv    
    FROM CUENTASPERSONA
    WHERE CuentaAhoID=Var_CuentaAhoId LIMIT 1;
    ELSE
      SET Var_NomProvRecurs       =Cadena_Vacia;
      SET Var_ApellidoPatProv        =Cadena_Vacia;
      SET Var_ApellidoMatProv        =Cadena_Vacia;
      SET Var_RfcProv                =Cadena_Vacia;
      SET Var_NacionProv             =Cadena_Vacia;
      SET Var_FechaNacProv           =Fecha_Vacia;
      SET Var_DomicilioProv          =Cadena_Vacia;
    END IF;
    

    -- PEP
        SELECT PEPs,      ParentescoPEP
        INTO   Var_Peps,  Var_ParentPep
        FROM CONOCIMIENTOCTE
        WHERE ClienteID=Var_ClienteID;
        
        
        
    SELECT  MAX(ClienteArchivosID) 
    INTO Var_CliArchID
    FROM CLIENTEARCHIVOS
    WHERE IF(Var_ClienteID <> Entero_Cero , ClienteID = Var_ClienteID, true)
    AND TipoDocumento = Var_DocuFirmaSolID;

    SET Var_CliArchID   := IFNULL(Var_CliArchID, Entero_Cero);

    SELECT  Recurso
    INTO    Var_RutaFirma
    FROM CLIENTEARCHIVOS
    WHERE ClienteArchivosID = Var_CliArchID;
    
    SET Var_RutaFirma := IFNULL(Var_RutaFirma, Cadena_Vacia);

    SELECT  Var_SolCreditoID,	Var_NombreSucurs,   Var_Numcliente,     Var_NombreCli,      Var_FecNacCli,      
            Var_PaisNac,        Var_EstadoNac,      Var_CliGenero,      Var_Ocupacion,      Var_CliNacion,      
            Var_DescriEstCiv,   Var_CliCURP,        Var_CliRFC,         Var_EscoCli,        Var_CliCalNum,      
            Var_CliColMun,      Var_1aEntreCalle,   Var_2aEntreCalle,   Var_CliTelTra,      Var_CliTelPart,     
            Var_CliValorViv,    Var_CliTipViv,      Var_CliMatViv,      Var_DirTrabajo,     Var_CliLugTra,      
            Var_CliPuesto, FORMAT(Var_DesCliAntTra,1) AS Var_DesCliAntTra, Var_ConyNomCom,  Var_ConyFecNac, Var_ConyPaiNac,     
            Var_ConyEstNac,     Var_ConyNomEmp,     Var_ConyTelTra,     Var_ConyTelCel,     Var_DirEmpCony,     
            Var_ConyAntTra,     Var_ClienteEdad,    Var_ConyugeEdad,    Var_ConyOcupa,      Var_ConyNacion,     
            Var_MontoSolici,    Var_Finalidad,      Var_Tasa,           Var_DesProducto,    Var_Plazo,          
            Var_Moneda,         Var_Destino,        Var_Frecuencia,     Var_TipoGarant,     Var_ClienteCiclo,   
            Var_NumCreTra,      Var_MonUltCred,     Var_NumDepend,      Var_NumHijos,       Var_NombrePromotor, 
            Var_NombreInstitucion,Var_DirecCompletSuc,Var_DirecSucursal,Var_CliTelCel,      Var_CliCorreo,      
            Var_CliObserva,     Var_UsuAltaSol,     Var_TipoIdentifi,   Var_NumIdentifi,    Var_TipoVivienda,   
            Var_ValorVivienda,  Var_TiempoHabVivienda, Var_CPCliente,   Var_PuestoCli,      Var_obserVivienda,  
            Var_TipoDispersion, Var_RecursoProvTer, Var_NomProvRecurs,  Var_ApellidoPatProv,Var_ApellidoMatProv,
            Var_RfcProv,        Var_FechaNacProv,   Var_NacionProv,     Var_DomicilioProv,  Var_DescrVivienda,  
            Var_CadTiempHabitVivien, Var_TrabajoObserv, Var_CPTrabajo,  Var_RutaFirma  ;

END IF; -- EndIF de Tipo de Reporte General o Datos del Cte y Solicitud

END TerminaStore$$
