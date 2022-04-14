-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INTEGRAGRUPOSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `INTEGRAGRUPOSALT`;
DELIMITER $$


CREATE PROCEDURE `INTEGRAGRUPOSALT`(
    Par_GrupoID            INT(11),    -- Identificador del grupo
    Par_SolicitudCreditoID  INT(11),   -- Identificador de la solicitud
    Par_ClienteID          INT(11),    -- Identificador del cliente
    Par_ProspectoID        INT(11),    -- Identificador del prospecto
    Par_Estatus            CHAR(1),    -- Estatus del grupo

    Par_FechaRegistro      DATETIME,    -- Fecha de registro
    Par_Ciclo              INT(11),     -- Ciclo o Numero de Credito del Cte
    Par_CicloGrupo         INT(11),     -- Ciclo Ponderado Grupal
    Par_Cargo              INT(11),     -- Cargo del integrante
    Par_Salida             CHAR(1),     -- Indica la salida de datos

    INOUT Par_NumErr       INT(11),
    INOUT Par_ErrMen       VARCHAR(400),
    /* Parametros de Auditoria */
    Aud_EmpresaID          INT(11),     -- Auditoria
    Aud_Usuario            INT(11),     -- Auditoria
    Aud_FechaActual        DATETIME,    -- Auditoria

    Aud_DireccionIP        VARCHAR(15), -- Auditoria
    Aud_ProgramaID         VARCHAR(50), -- Auditoria
    Aud_Sucursal           INT(11),     -- Auditoria
    Aud_NumTransaccion     BIGINT(20)   -- Auditoria
      )

TerminaStore: BEGIN

/* Declaracion de Variables */
DECLARE Var_DesCargo          VARCHAR(45);    -- Descripcion del cargo
DECLARE Var_EstGrupo          CHAR(1);        -- Estatus del grupo
DECLARE varControl            CHAR(20);       -- variable de control
DECLARE Var_SolEstatus        CHAR(1);        -- estatus de la solicitud de credito
DECLARE Var_SolProducCre      INT;            -- producto de credito de la solicitud
DECLARE Var_SolGrupal            CHAR(1);     -- Indica si es una solicitud grupal
DECLARE Var_IntSolCreID       BIGINT;         -- Id de la solicitud del integrante
DECLARE Var_IntGrupoID        INT;            -- Id del grupo
DECLARE Var_ClienteID         INT;            -- id del cliente
DECLARE Var_ProspectoID       INT;            -- id del prospecto
DECLARE Var_IntEstatus        CHAR(1);        -- Estatus del integrante
DECLARE Var_IntMonSol         DECIMAL(14,2);  -- monto de solicitud
DECLARE Var_NumIntegra        INT;            -- Numero de integrantes
DECLARE Var_CicloPond         INT;            -- numero de ciclo
DECLARE Var_PonderaCiclo      CHAR(1);        -- ponderado para el ciclo
DECLARE Var_TasaFija          DECIMAL(12,4);  -- Tasa fija
DECLARE Var_SucursalID        INT;            -- clave de la sucursal
DECLARE Var_NumTraSim         BIGINT;         -- Numero de transaccion
DECLARE Var_MonAutoriza       DECIMAL(14,2);  -- monto autorizado
DECLARE Var_MonConsul         DECIMAL(14,2);  -- monto de consulta
DECLARE Var_CalificaCredito      CHAR(1);     -- calificacion del credito
DECLARE Var_NombreGrupo       VARCHAR(200);   -- nombre del grupo
DECLARE  Var_DescCalCte       VARCHAR(100);   -- Calificacion del cliente
DECLARE Var_PlazoID           VARCHAR(20);    -- Plazo de credito
DECLARE Var_CalcInteres       INT(11);        -- Tipo de Calculo de interes

-- Variables para conocer el numero de integrantes
DECLARE Var_TotalInteg        INT;      -- Total de integrantes
DECLARE Var_TotaHomb          INT;      -- total de hombres
DECLARE Var_TotaMujer         INT;      --  total de mujeres
DECLARE Var_TotaMujerS        INT;      -- total de mujeres solteras
DECLARE Var_TotalIntegCte     INT;      -- total de integrantes que son clientes
DECLARE Var_TotalIntegPros    INT;      -- total de integrantes que son prospectos
DECLARE Var_TotaMujerCte      INT;      -- total de mujeres cliente
DECLARE Var_TotaMujerPros     INT;      -- total de mujeres prospecto
DECLARE Var_TotaHombCte       INT;      -- total de hombres cliente
DECLARE Var_TotaHombPros      INT;      -- total de hombres prospecto
DECLARE Var_TotaMujerCtes     INT;      -- total de mujeres
DECLARE Var_TotaMujerProsp    INT;      -- total de prospectos
DECLARE Var_ProductoCreditoID INT;      --  clave de producto
DECLARE Var_MinMujeresSol     INT;     --  minimo de mujeres solteres
DECLARE Var_MaxMujeresSol     INT;      --  maximo de mujeres solteras
DECLARE Var_MinMujeres        INT;     --  minimo de mujeres
DECLARE Var_MaxMujeres        INT;      -- maximo de mujeres
DECLARE Var_MinHombres        INT;      -- minimo de hombres
DECLARE Var_MaxHombres        INT;      -- maximo de hombres
DECLARE Var_MaxIntegrantes    INT;      -- maximo de integrantes del grupo
DECLARE Var_MinIntegrantes    INT;      -- minimo de integrantes de grupo
DECLARE Var_Sexo           	  CHAR(1);     -- sexo - genero
DECLARE Var_EstadoCivil       CHAR(2);      -- estado civil
DECLARE Var_Prorratea		  CHAR(1);
DECLARE Var_NivelID				INT(11);	-- Nivel del crédito (NIVELCREDITO).

/* Declaracion de Constamtes */
DECLARE Entero_Cero           INT(11);
DECLARE Cadena_Vacia          CHAR(1);
DECLARE Decimal_Cero          DECIMAL(12,2);
DECLARE SalidaSI              CHAR(1);
DECLARE SalidaNO              CHAR(1);
DECLARE Entero_Negativo       INT;
DECLARE Si_Prorrateo          CHAR(1);
DECLARE Gru_Cerrado           CHAR(1);
DECLARE Gru_NoIniciado        CHAR(1);
DECLARE Int_Activo            CHAR(1);
DECLARE Sol_Autoriza          CHAR(1);
DECLARE Es_Grupal             CHAR(1);
DECLARE Cargo_Presiden        CHAR(1);
DECLARE Cargo_Tesorero        CHAR(1);
DECLARE Cargo_Secretar        CHAR(1);
DECLARE Cargo_Integra         INT;
DECLARE Sol_Cancelada         CHAR(1);
DECLARE Sol_Desembol          CHAR(1);
DECLARE PonderaCiclo_SI       CHAR(1);
DECLARE PonderaCiclo_NO       CHAR(1);
DECLARE Sex_F                 CHAR(1);
DECLARE Sex_M                 CHAR(1);
DECLARE EdoSoltero            CHAR(2);
DECLARE Entero_Uno            INT(11);
DECLARE Var_NoSolicitudes     INT(11);
DECLARE TasaFijaID               INT(11);
DECLARE Var_InstitucionNominaID     INT(11);      -- Numero de empresa de Nomina

#CREDICLUB WS
    DECLARE Var_ValidaEsqTasa    CHAR(1);
    DECLARE Key_ValidaEsqTasa    VARCHAR(25);
   DECLARE Valida_SI          CHAR(1);
   DECLARE Valida_NO          CHAR(1);


/* DECLARACION DE CURSORES */
DECLARE CURSORINTEGRAGRUPOS CURSOR FOR
    SELECT SolicitudCreditoID, GrupoID, Estatus, ClienteID, ProspectoID

        FROM INTEGRAGRUPOSCRE
        WHERE GrupoID = Par_GrupoID
          AND Estatus = Int_Activo;

DECLARE CURSORGRUPOTASA CURSOR FOR
    SELECT Sol.SolicitudCreditoID, Sol.MontoSolici, Sol.SucursalID, Sol.NumTransacSim,
           Sol.Estatus, Sol.MontoAutorizado,Cli.CalificaCredito,InstitucionNominaID
        FROM INTEGRAGRUPOSCRE Ing,
             SOLICITUDCREDITO Sol
         INNER JOIN CLIENTES Cli ON Cli.ClienteID=Sol.ClienteID
        WHERE Ing.GrupoID   = Par_GrupoID
          AND Ing.SolicitudCreditoID = Sol.SolicitudCreditoID
          AND Ing.Estatus   = Int_Activo;

/* Asignacion de Constamtes */
SET Entero_Cero     := 0;              -- Entero Cero
SET Cadena_Vacia    := '';             -- Cadena Vacia
SET Decimal_Cero    := 0.00;           -- DECIMAL Cero
SET SalidaSI        := 'S';            -- Salida Si
SET SalidaNO        := 'N';            -- Salida No
SET Entero_Negativo := -1;             -- Entero Negativo
SET Si_Prorrateo    := 'S';            -- Si Prorratea
SET Gru_Cerrado     := 'C';            -- Estatus del Grupo: Cerrado
SET Gru_NoIniciado  := 'N';            -- Estatus del Grupo: No Iniciado
SET Int_Activo      := 'A';               -- Estatus Inactivo
SET Sol_Autoriza    := 'A';                 -- Solicitud Autorizada
SET Es_Grupal       := 'S';               -- Si es Grupal

SET Sol_Cancelada   := 'C';               -- Estatus de la Solicitud: Cancelada
SET Sol_Desembol    := 'D';               -- Estatus de la Solicitud: Desembolsada
SET PonderaCiclo_SI := 'S';               -- Si Pondera Ciclo
SET PonderaCiclo_NO := 'N';               -- No Pondera Ciclo
SET Cargo_Presiden  := 1;              -- Tipo de Integrante: Presidente
SET Cargo_Tesorero  := 2;              -- Tipo de Integrante: Tesorero
SET Cargo_Secretar  := 3;              -- Tipo de Integrante: Secretario
SET Cargo_Integra   := 4;              -- Tipo de Integrante: Integrante
SET Sex_F           := 'F';                 -- Genero: Femenino
SET Sex_M            := 'M';                 -- Genero: Masculino
SET EdoSoltero      := 'S';                 -- Estado Civil: Soltero
SET Entero_Uno    := 1;             -- Entero Uno
SET TasaFijaID    := 1;             -- ID de la formula para tasa fija (FORMTIPOCALINT)

/* ---  CREDICLUB WS ------------------------------------------------ */
   SET Valida_SI           := 'S';           -- Validar esquema de tasa
   SET Valida_NO           := 'N';           -- Validar esquema de tasa
   SET Key_ValidaEsqTasa      := 'ValidaEsqTasa'; -- llave valida esquema

   SELECT ValorParametro
         INTO Var_ValidaEsqTasa
         FROM PARAMETROSCRCBWS
         WHERE LlaveParametro = Key_ValidaEsqTasa;

   SET Var_ValidaEsqTasa := IFNULL(Var_ValidaEsqTasa,Valida_SI);
/* --- FIN  CREDICLUB WS ------------------------------------------------ */


ManejoErrores: BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      SET Par_NumErr := 999;
      SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                     'Disculpe las molestias que esto le ocasiona. Ref: SP-INTEGRAGRUPOSALT');
      SET varControl := 'SQLEXCEPTION' ;
    END;

   SET Par_GrupoID         := IFNULL(Par_GrupoID, Entero_Cero);
   SET Par_SolicitudCreditoID  := IFNULL(Par_SolicitudCreditoID, Entero_Cero);
   SET Par_Cargo           := IFNULL(Par_Cargo, Entero_Cero);

   IF(Par_GrupoID = Entero_Cero ) THEN
      SET Par_NumErr  := '001';
      SET Par_ErrMen  := 'El Grupo esta vacio.';
      SET varControl  := 'grupoID' ;
      LEAVE ManejoErrores;
   END IF;

   IF(Par_SolicitudCreditoID = Entero_Cero ) THEN
      SET Par_NumErr  := '002';
      SET Par_ErrMen  := 'La Solicitud de Credito esta vacia';
      SET varControl  := 'solicitudCreditoID' ;
      LEAVE ManejoErrores;
   END IF;

   IF(Par_Cargo = Entero_Cero ) THEN
      SET Par_NumErr  := '003';
      SET Par_ErrMen  := CONCAT("El Cargo dentro del Grupo es incorrecto, para la Solicitud: " ,
                     CONVERT(Par_SolicitudCreditoID, CHAR));
      SET varControl   := 'grupoID' ;
      LEAVE ManejoErrores;
   END IF;


   SELECT EstatusCiclo, CicloPonderado INTO Var_EstGrupo, Var_CicloPond
      FROM GRUPOSCREDITO
      WHERE GrupoID = Par_GrupoID;

   SET Var_EstGrupo    := IFNULL(Var_EstGrupo, Cadena_Vacia);

   IF(Var_EstGrupo = Gru_Cerrado OR Var_EstGrupo = Gru_NoIniciado)THEN
      SET Par_NumErr  := '004';
      SET Par_ErrMen  := CONCAT("El Grupo ", Par_GrupoID," debe estar Abierto para Asignar Integrantes");
      SET varControl  := 'grupoID' ;
      LEAVE ManejoErrores;
    END IF;
   SET Par_ClienteID   := IFNULL(Par_ClienteID, Entero_Cero);
   SET Par_ProspectoID := IFNULL(Par_ProspectoID, Entero_Cero);

      IF(Par_ClienteID != Entero_Cero)THEN

      SELECT  	Sol.Estatus,        Sol.ProductoCreditoID,  Pro.EsGrupal,          	Pro.TasaPonderaGru, Sol.SucursalID,
				Sol.MontoSolici,	Sol.MontoAutorizado,  	Cli.CalificaCredito,	Sol.PlazoID,      	Sol.InstitucionNominaID,
				ProrrateoPago
            INTO
				Var_SolEstatus,   	Var_SolProducCre,    	Var_SolGrupal,       	Var_PonderaCiclo,   Var_SucursalID,
				Var_IntMonSol,    	Var_MonAutoriza,     	Var_CalificaCredito, 	Var_PlazoID,      	Var_InstitucionNominaID,
				Var_Prorratea
         FROM SOLICITUDCREDITO Sol,
             PRODUCTOSCREDITO Pro
            INNER JOIN CLIENTES Cli
         WHERE Sol.SolicitudCreditoID = Par_SolicitudCreditoID
           AND Sol.ProductoCreditoID = Pro.ProducCreditoID
           AND Cli.ClienteID=Sol.ClienteID;
      ELSE
      SELECT  	Sol.Estatus,        Sol.ProductoCreditoID,  Pro.EsGrupal,          		Pro.TasaPonderaGru, Sol.SucursalID,
				Sol.MontoSolici,    Sol.MontoAutorizado,  	Prosp.CalificaProspecto,	Sol.PlazoID,		Sol.InstitucionNominaID,
				ProrrateoPago
            INTO
				Var_SolEstatus,   	Var_SolProducCre,    	Var_SolGrupal,          	Var_PonderaCiclo,   Var_SucursalID,
				Var_IntMonSol,    	Var_MonAutoriza,     	Var_CalificaCredito,    	Var_PlazoID,      	Var_InstitucionNominaID,
                Var_Prorratea
         FROM SOLICITUDCREDITO Sol,
             PRODUCTOSCREDITO Pro
            INNER JOIN PROSPECTOS   Prosp
         WHERE Sol.SolicitudCreditoID = Par_SolicitudCreditoID
           AND Sol.ProductoCreditoID = Pro.ProducCreditoID
           AND Prosp.ProspectoID=Sol.ProspectoID;
      END IF;

   SET Var_SolEstatus  := IFNULL(Var_SolEstatus, Cadena_Vacia);
   SET Var_SolGrupal  := IFNULL(Var_SolGrupal, Cadena_Vacia);

   IF (Var_SolEstatus = Sol_Cancelada OR Var_SolEstatus = Sol_Desembol) THEN
      SET Par_NumErr  := '005';
      SET Par_ErrMen  := CONCAT("La Solicitud ", CONVERT(Par_SolicitudCreditoID, CHAR),
                  " esta Cancelada o Desembolsada.");
      SET varControl  := 'grupoID' ;
      LEAVE ManejoErrores;
   END IF;

   IF (Var_SolGrupal != Es_Grupal) THEN
      SET Par_NumErr  := '006';
      SET Par_ErrMen  := CONCAT("La Solicitud ", CONVERT(Par_SolicitudCreditoID, CHAR),
                  " no es de un Producto Grupal.");
      SET varControl  := 'grupoID' ;
      LEAVE ManejoErrores;
   END IF;

   SELECT COUNT(SolicitudCreditoID)INTO Var_NoSolicitudes
      FROM INTEGRAGRUPOSCRE
         WHERE SolicitudCreditoID=Par_SolicitudCreditoID;

   IF(IFNULL(Var_NoSolicitudes,Entero_Cero)>=Entero_Uno) THEN
      SET Par_NumErr  := '021';
      SET Par_ErrMen  := CONCAT("La Solicitud ", CONVERT(Par_SolicitudCreditoID, CHAR),
                             " ya se encuentra integrada a otro Grupo.");
      LEAVE ManejoErrores;
   END IF;


   OPEN CURSORINTEGRAGRUPOS;
      BEGIN
         DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
         CICLOINTEGRA:LOOP
         FETCH CURSORINTEGRAGRUPOS  INTO
            Var_IntSolCreID,    Var_IntGrupoID, Var_IntEstatus, Var_ClienteID,   Var_ProspectoID;

         SET Var_ClienteID   := IFNULL(Var_ClienteID, Entero_Cero);
         SET Var_ProspectoID := IFNULL(Var_ProspectoID, Entero_Cero);

            IF ( Var_IntSolCreID = Par_SolicitudCreditoID ) THEN
               SET Par_NumErr  := '010';
               SET Par_ErrMen  := CONCAT("La Solicitud ", CONVERT(Var_IntSolCreID, CHAR),
                                      " ya esta como Integrante en este Grupo.");
               LEAVE CICLOINTEGRA;
            END IF;

            IF ( Par_ClienteID != Entero_Cero AND  Par_ClienteID = Var_ClienteID ) THEN
               SET Par_NumErr  := '010';
               SET Par_ErrMen  := CONCAT("El cliente ", CONVERT(Var_ClienteID, CHAR),
                                    " ya se encuentra integrado al grupo con la solicitud ",CONVERT(Var_IntSolCreID, CHAR)," .");
               LEAVE CICLOINTEGRA;

            ELSE
               IF ( Par_ProspectoID != Entero_Cero AND  Par_ProspectoID = Var_ProspectoID ) THEN
                  SET Par_NumErr  := '010';
                  SET Par_ErrMen  := CONCAT("El prospecto ", CONVERT(Var_ProspectoID, CHAR),
                                       " ya se encuentra integrado al grupo con la solicitud ",CONVERT(Var_IntSolCreID, CHAR)," .");
                  LEAVE CICLOINTEGRA;
               END IF;
            END IF;
            SET Var_NombreGrupo :=(SELECT NombreGrupo
                                 FROM INTEGRAGRUPOSCRE      Inte
                                    LEFT JOIN GRUPOSCREDITO Gru ON Inte.GrupoID = Gru.GrupoID
                                 WHERE Inte.SolicitudCreditoID = Par_SolicitudCreditoID
                                    AND Estatus = Int_Activo  LIMIT 1);
         SET Var_NombreGrupo :=IFNULL(Var_NombreGrupo,Cadena_Vacia);

         IF(Var_NombreGrupo != Cadena_Vacia)THEN
            SET Par_NumErr  := '011';
               SET Par_ErrMen  := CONCAT("La Solicitud ", CONVERT(Par_SolicitudCreditoID, CHAR),
                                      " se encuentra integrada en el grupo ", Var_NombreGrupo);
               LEAVE CICLOINTEGRA;
         END IF;

         END LOOP CICLOINTEGRA;
      END;
   CLOSE CURSORINTEGRAGRUPOS;

   IF (Par_NumErr != Entero_Cero)THEN
      LEAVE ManejoErrores;
   END IF;


   IF (Par_Cargo <> Cargo_Integra) THEN
      IF(EXISTS(SELECT Ing.Cargo
         FROM INTEGRAGRUPOSCRE Ing
            WHERE    Ing.Cargo = Par_Cargo
            AND   Ing.GrupoID=Par_GrupoID
            AND   Ing.Estatus =Int_Activo))THEN

         IF (Par_Cargo = Cargo_Presiden)THEN
            SET Var_DesCargo := 'Presidente';
         END IF;
         IF (Par_Cargo = Cargo_Tesorero)THEN
            SET Var_DesCargo := 'Tesorero';
         END IF;
         IF (Par_Cargo = Cargo_Secretar)THEN
            SET Var_DesCargo := 'Secretario';
         END IF;

         SET Par_NumErr :='011';
            SET Par_ErrMen := CONCAT("Solo puede existir un ",Var_DesCargo," en el Grupo");
            SET varControl := 'cargoID' ;
            LEAVE ManejoErrores;
        END IF;
   END IF;

   /* VALIDAR NUMERO DE INTEGRANTES PERMITIDOS POR PRODUCTO DE CREDITO */

   IF(IFNULL(Par_ClienteID,Entero_Cero)!=Entero_Cero)THEN
      SELECT   Sexo,       EstadoCivil
       INTO    Var_Sexo,   Var_EstadoCivil
         FROM CLIENTES
            WHERE ClienteID = Par_ClienteID;
   ELSE
       SELECT  Sexo,       EstadoCivil
       INTO    Var_Sexo,   Var_EstadoCivil
         FROM PROSPECTOS
            WHERE ProspectoID = Par_ProspectoID;
   END IF;

   -- Total de Mujeres Solteras que son Clientes
   SELECT COUNT(Ing.ClienteID) INTO Var_TotaMujerCte
   FROM  CLIENTES Cli,
         INTEGRAGRUPOSCRE Ing
   WHERE Ing.ClienteID        = Cli.ClienteID
      AND Cli.Sexo            = Sex_F
      AND Cli.EstadoCivil        = EdoSoltero
      AND Ing.GrupoID             = Par_GrupoID;
   -- Total de Mujeres Solteras que son Prospectos
   SELECT COUNT(Ing.ProspectoID) INTO Var_TotaMujerPros
   FROM  PROSPECTOS P,
         INTEGRAGRUPOSCRE Ing
   WHERE Ing.ProspectoID         = P.ProspectoID
      AND P.Sexo              = Sex_F
      AND P.EstadoCivil       = EdoSoltero
      AND Ing.GrupoID             = Par_GrupoID
      AND IFNULL(P.ClienteID,Entero_Cero)=Entero_Cero;
   SELECT (Var_TotaMujerCte+Var_TotaMujerPros)INTO Var_TotaMujerS;

   -- Total de Mujeres que son Clientes
   SELECT  COUNT(Ing.ClienteID)  INTO Var_TotaMujerCtes
   FROM  INTEGRAGRUPOSCRE Ing,
         CLIENTES Cli
   WHERE  Ing.ClienteID       = Cli.ClienteID
      AND Cli.Sexo            = Sex_F
      AND Ing.GrupoID             = Par_GrupoID;
   -- Total de Mujeres que son Prospectos
   SELECT  COUNT(Ing.ProspectoID)  INTO Var_TotaMujerProsp
   FROM  INTEGRAGRUPOSCRE Ing,
         PROSPECTOS P
   WHERE  Ing.ProspectoID        = P.ProspectoID
      AND P.Sexo              = Sex_F
      AND Ing.GrupoID             = Par_GrupoID
      AND IFNULL(P.ClienteID,Entero_Cero)=Entero_Cero;

   SELECT (Var_TotaMujerCtes + Var_TotaMujerProsp)INTO Var_TotaMujer;

   -- Total de Hombres que son Clientes
   SELECT  COUNT(Ing.ClienteID)  INTO Var_TotaHombCte
   FROM  INTEGRAGRUPOSCRE Ing,
         CLIENTES Cli
   WHERE Ing.GrupoID               = Par_GrupoID
      AND Ing.ClienteID       = Cli.ClienteID
      AND Cli.Sexo            = Sex_M;
   -- Total de Hombres que son Prospectos
   SELECT  COUNT(Ing.ProspectoID)  INTO Var_TotaHombPros
   FROM  INTEGRAGRUPOSCRE Ing,
         PROSPECTOS P
   WHERE Ing.GrupoID               = Par_GrupoID
      AND Ing.ProspectoID        = P.ProspectoID
      AND P.Sexo              = Sex_M
      AND IFNULL(P.ClienteID,Entero_Cero)=Entero_Cero;

   SELECT (Var_TotaHombCte+Var_TotaHombPros) INTO Var_TotaHomb;

   SELECT ProductoCreditoID INTO Var_ProductoCreditoID
    FROM SOLICITUDCREDITO
      WHERE SolicitudCreditoID = Par_SolicitudCreditoID;

   SELECT   MinMujeresSol,    MaxMujeresSol,    MinMujeres,       MaxMujeres,       MinHombres,
         MaxHombres,       MaxIntegrantes,      MinIntegrantes,      CalcInteres
   INTO  Var_MinMujeresSol,   Var_MaxMujeresSol,   Var_MinMujeres,   Var_MaxMujeres,      Var_MinHombres,
         Var_MaxHombres,      Var_MaxIntegrantes,  Var_MinIntegrantes,  Var_CalcInteres
    FROM PRODUCTOSCREDITO
    WHERE ProducCreditoID = Var_ProductoCreditoID;

   SET Var_MinMujeresSol   := IFNULL(Var_MinMujeresSol, Entero_Cero);
   SET Var_MaxMujeresSol   := IFNULL(Var_MaxMujeresSol, Entero_Cero);
   SET Var_MinMujeres      := IFNULL(Var_MinMujeres, Entero_Cero);
   SET Var_MaxMujeres      := IFNULL(Var_MaxMujeres, Entero_Cero);
   SET Var_MinHombres      := IFNULL(Var_MinHombres, Entero_Cero);
   SET Var_MaxHombres      := IFNULL(Var_MaxHombres, Entero_Cero);
   SET Var_MaxIntegrantes  := IFNULL(Var_MaxIntegrantes, Entero_Cero);
   SET Var_MinIntegrantes  := IFNULL(Var_MinIntegrantes, Entero_Cero);

   SET Var_TotaMujerS      := IFNULL(Var_TotaMujerS, Entero_Cero);
   SET Var_TotaMujer    := IFNULL(Var_TotaMujer, Entero_Cero);
   SET Var_TotaHomb     := IFNULL(Var_TotaHomb, Entero_Cero);
   SET Var_TotalInteg      := Var_TotaMujer + Var_TotaHomb;

   IF(Var_Sexo=Sex_F)THEN
      IF(Var_EstadoCivil=EdoSoltero)THEN
         SET Var_TotaMujerS   := Var_TotaMujerS + Entero_Uno;
      END IF;
      SET Var_TotaMujer    := Var_TotaMujer + Entero_Uno;
   ELSE
      SET Var_TotaHomb  := Var_TotaHomb + Entero_Uno;
   END IF;

   SET Var_TotalInteg   := Var_TotalInteg + Entero_Uno;

   IF(Var_TotalInteg>Var_MaxIntegrantes)THEN
       SET Par_NumErr  := '020';
       SET Par_ErrMen  := 'Se ha Alcanzado el Numero Maximo de Integrantes para el Grupo.';
       SET varControl  := 'solicitudCreditoID' ;
      LEAVE ManejoErrores;
   ELSE
      IF(Var_TotaMujerS>Var_MaxMujeresSol)THEN
         IF(Var_MaxMujeresSol=Entero_Uno)THEN
             SET Par_NumErr  := '012';
             SET Par_ErrMen  := 'El Producto de Credito no Admite Mujeres Solteras.';
             SET varControl  := 'solicitudCreditoID' ;
            LEAVE ManejoErrores;
         ELSE
             SET Par_NumErr  := '013';
             SET Par_ErrMen  := 'Se ha Alcanzado el Numero Maximo de Mujeres Solteras para el Grupo.';
             SET varControl  := 'solicitudCreditoID' ;
            LEAVE ManejoErrores;
         END IF;
      ELSE
         IF(Var_TotaMujer>Var_MaxMujeres)THEN
            IF(Var_MaxMujeres=Entero_Uno)THEN
                SET Par_NumErr  := '014';
                SET Par_ErrMen  := 'El Producto de Credito no Admite Mujeres.';
                SET varControl  := 'solicitudCreditoID' ;
               LEAVE ManejoErrores;
            ELSE
                SET Par_NumErr  := '015';
                SET Par_ErrMen  := 'Se ha Alcanzado el Numero Maximo de Mujeres para el Grupo.';
                SET varControl  := 'solicitudCreditoID' ;
               LEAVE ManejoErrores;
            END IF;
         ELSE
            IF(Var_TotaHomb>Var_MaxHombres)THEN
               IF(Var_MaxHombres=Entero_Uno)THEN
                   SET Par_NumErr  := '016';
                   SET Par_ErrMen  := 'El Producto de Credito no Admite Hombres.';
                   SET varControl  := 'solicitudCreditoID' ;
                  LEAVE ManejoErrores;
               ELSE
                   SET Par_NumErr  := '017';
                   SET Par_ErrMen  := 'Se ha Alcanzado el Numero Maximo de Hombres para el Grupo.';
                   SET varControl  := 'solicitudCreditoID' ;
                  LEAVE ManejoErrores;
               END IF;
            ELSE
               IF((Var_MaxMujeres-Var_MinMujeresSol)<(Var_TotaMujer-Var_TotaMujerS))THEN
                  IF((Var_MaxMujeres-Var_MinMujeresSol)=Entero_Uno)THEN
                      SET Par_NumErr  := '018';
                      SET Par_ErrMen  := 'El Producto de Credito Solo Admite Mujeres Solteras.';
                      SET varControl  := 'solicitudCreditoID' ;
                     LEAVE ManejoErrores;
                  ELSE
                      SET Par_NumErr  := '019';
                      SET Par_ErrMen  := 'Se ha Alcanzado el Numero Maximo de Mujeres No Solteras para el Grupo.';
                      SET varControl  := 'solicitudCreditoID' ;
                     LEAVE ManejoErrores;
                  END IF;
               END IF;
            END IF; -- MaxHombres
         END IF; -- MaxMujeres
      END IF; -- MaxMujeresSol
   END IF; -- MaxIntegrantes

   /*  FIN VALIDAR NUMERO DE INTEGRANTES PERMITIDOS POR PRODUCTO DE CREDITO */

   /* Sp que se utiliza para validar que todos los valores en un grupo de solicitudes de
      credito sean iguales (producto de credito,  plazo, frecuencias y demas valores
      para generar el calendario de pagos) */
   CALL SOLCREGRUALTMODVAL(
      Par_SolicitudCreditoID, Par_ProspectoID,  Par_ClienteID, Par_GrupoID,      Par_Cargo,
      SalidaNO,            Par_NumErr,       Par_ErrMen,    Aud_EmpresaID,    Aud_Usuario,
      Aud_FechaActual,     Aud_DireccionIP,  Aud_ProgramaID,   Aud_Sucursal,     Aud_NumTransaccion);


   IF (Par_NumErr <> Entero_Cero)THEN
      LEAVE ManejoErrores;
   END IF;

   SET Var_TasaFija    := Entero_Cero;

   SET Aud_FechaActual := CURRENT_TIMESTAMP();

   -- Calculo del Ciclo(No de Creditos del mismo Producto), el individual y el del Grupo Ponderado
   SET Par_Ciclo := IFNULL(Par_Ciclo, Entero_Cero);
   SET Par_CicloGrupo := IFNULL(Par_CicloGrupo, Entero_Cero);

   CALL CRECALCULOCICLOPRO(
      Par_ClienteID,      Par_ProspectoID,    Var_SolProducCre,   Par_GrupoID,    Par_Ciclo,
      Par_CicloGrupo,      SalidaNO,           Aud_EmpresaID,      Aud_Usuario,    Aud_FechaActual,
      Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

   INSERT INTO INTEGRAGRUPOSCRE(
      `GrupoID`,          `SolicitudCreditoID`,   `ClienteID`,    `ProspectoID`,  `Estatus`,
      `ProrrateaPago`,    `FechaRegistro`,        `Ciclo`,        `EmpresaID`,    `Usuario`,
      `FechaActual`,      `DireccionIP`,          `ProgramaID`,   `Sucursal`,     `NumTransaccion`,
      `Cargo`
   ) VALUES (
      Par_GrupoID,        Par_SolicitudCreditoID, Par_ClienteID,  Par_ProspectoID,    Par_Estatus,
      Var_Prorratea,      Par_FechaRegistro,      Par_Ciclo,      Aud_EmpresaID,      Aud_Usuario,
      Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID, Aud_Sucursal,       Aud_NumTransaccion,
      Par_Cargo);


   IF(Var_PonderaCiclo = PonderaCiclo_SI) THEN

      SELECT COUNT(Ing.GrupoID) INTO Var_NumIntegra
         FROM INTEGRAGRUPOSCRE Ing,
            SOLICITUDCREDITO Sol
         WHERE Ing.GrupoID = Par_GrupoID
         AND Ing.Estatus = Int_Activo
         AND Ing.SolicitudCreditoID = Sol.SolicitudCreditoID
         GROUP BY Ing.GrupoID;

      UPDATE GRUPOSCREDITO SET
         CicloPonderado = Par_CicloGrupo
         WHERE GrupoID = Par_GrupoID;

      /* Si el calculo de Interes es por Tasa Fija
       * se actualiza la tasa de acuerdo al esquema de tasas */
      IF(IFNULL(Var_CalcInteres,Entero_Cero)=TasaFijaID AND Var_ValidaEsqTasa <> Valida_NO)THEN
         IF(Var_NumIntegra != Entero_Cero) THEN
            OPEN CURSORGRUPOTASA;
            BEGIN
               DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
               CICLOINTASA:LOOP
               FETCH CURSORGRUPOTASA  INTO
                  Var_IntSolCreID,    Var_IntMonSol,  Var_SucursalID,      Var_NumTraSim,
                  Var_SolEstatus,     Var_MonAutoriza,Var_CalificaCredito, Var_InstitucionNominaID;

                  SET Var_MonConsul := Entero_Cero;
                  IF(Var_SolEstatus = Sol_Autoriza) THEN
                     SET Var_MonConsul := Var_MonAutoriza;
                  ELSE
                     SET Var_MonConsul := Var_IntMonSol;
                  END IF;

                  SET Var_MonConsul := IFNULL(Var_MonConsul, Entero_Cero);

                  CALL ESQUEMATASACALPRO(
                     Var_SucursalID,	Var_SolProducCre,   Par_CicloGrupo,				Var_MonConsul,	Var_CalificaCredito,
                     Var_TasaFija,		Var_PlazoID,		Var_InstitucionNominaID,	Entero_Cero,	Var_NivelID,
                     SalidaNO,			Par_NumErr,			Par_ErrMen,					Aud_EmpresaID,	Aud_Usuario,
                     Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,				Aud_Sucursal,	Aud_NumTransaccion  );


                  IF(Var_TasaFija <= Decimal_Cero) THEN
                     SET Par_NumErr  := 999;
                     SET Par_ErrMen  := CONCAT('No existe esquema de Tasa para la Solicitud: ',
                                         CONVERT(Var_IntSolCreID, CHAR),
                                       ' con Ciclo: ',CONVERT(Par_CicloGrupo,CHAR),
                                       '  y Calificacion: ',CASE WHEN Var_CalificaCredito ='A'THEN 'Excelente'
                                                         WHEN Var_CalificaCredito ='N'THEN 'No Asignada'
                                                         WHEN Var_CalificaCredito ='B'THEN 'Buena'
                                                         WHEN Var_CalificaCredito ='C'THEN 'Regular' END );
                     LEAVE CICLOINTASA;
                  END IF;


                  UPDATE SOLICITUDCREDITO SET
                     TasaFija = Var_TasaFija,
                     NivelID = IFNULL(Var_NivelID,Entero_Cero),
                     NumTransacSim   = Entero_Cero
                     WHERE SolicitudCreditoID = Par_SolicitudCreditoID;

                  DELETE FROM TMPPAGAMORSIM
                     WHERE NumTransaccion    = Var_NumTraSim;

               END LOOP CICLOINTASA;
            END;
            CLOSE CURSORGRUPOTASA;

            IF (Par_NumErr <> Entero_Cero)THEN
               LEAVE ManejoErrores;
            END IF;
         END IF;
      END IF;
   ELSE    -- ELSE de Var_PonderaCiclo = PonderaCiclo_SI
      /* Si el calculo de Interes es por Tasa Fija
       * se actualiza la tasa de acuerdo al esquema de tasas */
      IF(IFNULL(Var_CalcInteres,Entero_Cero)=TasaFijaID AND Var_ValidaEsqTasa <> Valida_NO)THEN
         SET Var_MonConsul := Entero_Cero;
         IF(Var_SolEstatus = Sol_Autoriza) THEN
            SET Var_MonConsul := Var_MonAutoriza;
         ELSE
            SET Var_MonConsul := Var_IntMonSol;
         END IF;

         SET Var_MonConsul := IFNULL(Var_MonConsul, Entero_Cero);

         CALL ESQUEMATASACALPRO(
            Var_SucursalID,		Var_SolProducCre,   Par_Ciclo,					Var_MonConsul,	Var_CalificaCredito,
            Var_TasaFija,		Var_PlazoID,		Var_InstitucionNominaID,	Entero_Cero,	Var_NivelID,
            SalidaNO,			Par_NumErr,			Par_ErrMen,					Aud_EmpresaID,	Aud_Usuario,
            Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,				Aud_Sucursal,	Aud_NumTransaccion   );

         IF(Var_TasaFija <= Entero_Cero) THEN
            SET Par_NumErr  := 999;
            SET Par_ErrMen  := CONCAT('No existe esquema de Tasa para la Solicitud: ',
                                CONVERT(Var_IntSolCreID, CHAR));
            LEAVE ManejoErrores;
         END IF;

         UPDATE SOLICITUDCREDITO SET
            TasaFija = Var_TasaFija,
			NivelID = IFNULL(Var_NivelID,Entero_Cero),
            NumTransacSim   = Entero_Cero
            WHERE SolicitudCreditoID = Par_SolicitudCreditoID;


         DELETE FROM TMPPAGAMORSIM
            WHERE NumTransaccion    = Var_NumTraSim;
      END IF;
   END IF;

   SET   Par_NumErr := 0;
   SET   Par_ErrMen := "Integrantes Asignados Correctamente";

   UPDATE SOLICITUDCREDITO SET
      GrupoID = Par_GrupoID
      WHERE SolicitudCreditoID = Par_SolicitudCreditoID;

END ManejoErrores;

IF(Par_Salida = SalidaSI) THEN
    SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
            Par_ErrMen AS ErrMen,
            varControl AS control,
            Entero_Cero AS consecutivo;
END IF;

END TerminaStore$$