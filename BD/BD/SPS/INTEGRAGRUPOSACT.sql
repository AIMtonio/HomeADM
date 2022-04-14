-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INTEGRAGRUPOSACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `INTEGRAGRUPOSACT`;DELIMITER $$

CREATE PROCEDURE `INTEGRAGRUPOSACT`(
    Par_Grupo           INT(11),
    Par_Solicitud       BIGINT(20),
    Par_Cliente         INT(11),
    Par_Prospecto       INT(11),
    Par_Estatus         CHAR(1),
    Par_FechaRegistro   DATETIME,
    Par_Ciclo           INT(11),
    Par_Cargo           INT(11),
    Par_TipoActualiza   INT(11),

    Par_Salida          CHAR(1),
    inout Par_NumErr    INT(11),
    inout Par_ErrMen    VARCHAR(400),

    Aud_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)

		)
TerminaStore: BEGIN


DECLARE Var_DesCargo    VARCHAR(45);
DECLARE Var_EstGrupo    CHAR(1);
DECLARE Var_Control      VARCHAR(18);

DECLARE Var_SolEstatus      CHAR(1);
DECLARE Var_SolFrecCap      CHAR(1);
DECLARE Var_SolPerioCap     INT;
DECLARE Var_SolProducCre    INT;
DECLARE Var_SolNumAmorti    INT;
DECLARE Var_SolGrupal       CHAR(1);
DECLARE Var_SolDiaPago      CHAR(1);
DECLARE Var_SolDiaMes       INT;

DECLARE Var_IntFrecCap      CHAR(1);
DECLARE Var_IntPerCap       INT;
DECLARE Var_IntNumAmorti    INT;
DECLARE Var_IntDiaPago      CHAR(1);
DECLARE Var_IntDiaMes       INT;

DECLARE Var_IntSolCreID BIGINT;
DECLARE Var_IntGrupoID  INT;
DECLARE Var_IntEstatus  CHAR(1);



DECLARE Entero_Cero             INT;
DECLARE Cadena_Vacia            CHAR(1);
DECLARE Decimal_Cero            DECIMAL(12,2);
DECLARE SalidaSI                CHAR(1);
DECLARE SalidaNO                CHAR(1);
DECLARE Entero_Negativo         INT(11);
DECLARE Si_Prorrateo            CHAR(1);
DECLARE Gru_Cerrado             CHAR(1);
DECLARE Gru_NoIniciado          CHAR(1);
DECLARE Int_StaActivo           CHAR(1);
DECLARE Int_StaRechazado        CHAR(1);
DECLARE Es_Grupal               CHAR(1);
DECLARE Cargo_Presiden          CHAR(1);
DECLARE Cargo_Tesorero          CHAR(1);
DECLARE Cargo_Secretar          CHAR(1);
DECLARE Cargo_Integra           INT(11);
DECLARE Sol_Cancelada           CHAR(1);
DECLARE Sol_Desembol            CHAR(1);
DECLARE Act_RechazarInteg       INT(11);
DECLARE Act_DesasignaInteg		INT(11);

DECLARE CURSORINTEGRAGRUPOS CURSOR FOR
    SELECT SolicitudCreditoID, GrupoID, Estatus
        FROM INTEGRAGRUPOSCRE
        WHERE SolicitudCreditoID = Par_SolicitudCreditoID;


SET Entero_Cero             := 0;
SET Cadena_Vacia            := '';
SET Decimal_Cero            := 0.00;
SET SalidaSI                := 'S';
SET SalidaNO                := 'N';
SET Entero_Negativo         := -1;
SET Si_Prorrateo            := 'S';
SET Gru_Cerrado             := 'C';
SET Gru_NoIniciado          := 'N';
SET Int_StaActivo           := 'A';
SET Int_StaRechazado        := 'R';
SET Es_Grupal               := 'S';

SET Cargo_Presiden          := 1;
SET Cargo_Tesorero          := 2;
SET Cargo_Secretar          := 3;
SET Cargo_Integra           := 4;

SET Sol_Cancelada           := 'C';
SET Sol_Desembol            := 'D';

SET Act_RechazarInteg       := 1;
SET Act_DesasignaInteg		:=2;

SET	Par_NumErr := 1;
SET	Par_ErrMen := Cadena_Vacia;

ManejoErrores: BEGIN
			DECLARE EXIT HANDLER FOR SQLEXCEPTION
				BEGIN
					SET Par_NumErr = 999;
					SET Par_ErrMen = CONCAT("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
								 "estamos trabajando para resolverla. Disculpe las molestias que ",
								 "esto le ocasiona. Ref: SP-INTEGRAGRUPOSACT");
				END;


    SET Par_Grupo       := ifnull(Par_Grupo, Entero_Cero);
    SET Par_Solicitud   := ifnull(Par_Solicitud, Entero_Cero);
    SET Par_Cargo       := ifnull(Par_Cargo, Entero_Cero);



    IF Par_TipoActualiza = Act_RechazarInteg THEN
        IF(Par_Grupo = Entero_Cero ) THEN
			SET	Par_NumErr	:= 1;
            SET Par_ErrMen  := 'El Grupo esta vacio';
			SET Var_Control	:='solicitudCreditoID';
            LEAVE ManejoErrores;
        END IF;

        IF(Par_Solicitud = Entero_Cero ) THEN
			SET	Par_NumErr	:= 2;
            SET Par_ErrMen  := 'El Grupo esta vacio';
			SET Var_Control	:='solicitudCreditoID';
            LEAVE ManejoErrores;
        END IF;

        IF not exists(SELECT SolicitudCreditoID
                      FROM SOLICITUDCREDITO
                      WHERE SolicitudCreditoID = Par_Solicitud) THEN
			SET	Par_NumErr	:= 3;
            SET Par_ErrMen  := 'La Solicitud no existe';
			SET Var_Control	:='solicitudCreditoID';
            LEAVE ManejoErrores;
        END IF;

        SET Aud_FechaActual := CURRENT_TIMESTAMP();

        UPDATE INTEGRAGRUPOSCRE
        SET  Estatus        = Int_StaRechazado
            ,EmpresaID      = Aud_EmpresaID
            ,Usuario        = Aud_Usuario
            ,FechaActual    = Aud_FechaActual
            ,DireccionIP    = Aud_DireccionIP
            ,ProgramaID     = Aud_ProgramaID
            ,Sucursal       = Aud_Sucursal
            ,NumTransaccion = Aud_NumTransaccion
        WHERE   GrupoID             = Par_Grupo
          AND   SolicitudCreditoID  = Par_Solicitud;

        SET	Par_NumErr := 0;
        SET	Par_ErrMen := "Integrante de Grupo Rechazado con Exito";
		SET Var_Control	:='solicitudCreditoID';
		LEAVE ManejoErrores;
    END IF;


	IF Par_TipoActualiza = Act_DesasignaInteg THEN
		 IF(ifnull(Par_Grupo, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:=1;
            SET Par_ErrMen  := 'El Grupo esta vacio';
            LEAVE ManejoErrores;
		END IF;

		DELETE FROM INTEGRAGRUPOSCRE
			WHERE   GrupoID	= Par_Grupo;

		SET Par_NumErr	:=0;
		SET Par_ErrMen  := 'Integrantes Desasignados';
		LEAVE ManejoErrores;

	END IF;

END ManejoErrores;
	IF (Par_Salida = SalidaSI) THEN
            SELECT  Par_NumErr AS NumErr,
                    Par_ErrMen AS ErrMen,
                    Var_Control AS control,
                    Entero_Cero AS consecutivo;
        END IF;
END TerminaStore$$