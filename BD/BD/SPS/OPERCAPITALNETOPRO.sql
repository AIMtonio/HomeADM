-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- OPERCAPITALNETOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `OPERCAPITALNETOPRO`;
DELIMITER $$

CREATE PROCEDURE `OPERCAPITALNETOPRO`(
# ======================================================================================================
# -------PROCESO ENCARGADO DE PROCESAR LAS OPERACIONES DETECTADAS DEL CAPITAL NETO DE LA ENTIDAD--------
# ======================================================================================================
    Par_OperacionID		    INT(11),		    -- Numero de operacion
    Par_InstrumentoID		BIGINT(12),		    -- Numero de instrumento a validar
    Par_PantallaOrigen		VARCHAR(3),		    -- PANTALLA AS.-Autorizacion Solicitud Cred. AI.-Autorizacion Inversion AC.-Autorizacion CEDE AC.-ABONO A CUENTA
    Par_Montivo 			VARCHAR(1000),	    -- Motivo del proceso
    Par_NumAct              TINYINT UNSIGNED,   -- Numero de Actualizacion

    Par_Salida				CHAR(1),		    -- Indica Salida
    INOUT Par_NumErr		INT(11),		    -- Inout NumErr
    INOUT Par_ErrMen		VARCHAR(400),	    -- Inout ErrMen

    Aud_EmpresaID			INT(11),            -- Parametro de Auditoria Par_Empresa.
    Aud_Usuario				INT(11),		    -- Parametro de Auditoria Aud_Usuario.
    Aud_FechaActual			DATETIME,		    -- Parametro de Auditoria Aud_FechaActual.
    Aud_DireccionIP			VARCHAR(15),	    -- Parametro de Auditoria Aud_DireccionIP.
    Aud_ProgramaID			VARCHAR(50),	    -- Parametro de Auditoria Aud_ProgramaID.
    Aud_Sucursal			INT(11),		    -- Parametro de Auditoria Aud_Sucursal.
    Aud_NumTransaccion		BIGINT(20)		    -- Parametro de Auditoria Aud_Numtransaccion.
)
TerminaStored:BEGIN

-- DECLARACION DE VARIABLES
DECLARE Var_Control				VARCHAR(100);	-- CONTROL
DECLARE Var_FechaSistema		DATE;			-- FECHA DEL SISTEMA
DECLARE Var_FechaSucursal       DATE;           -- FECHA DE LA SUCURSAL
DECLARE Var_PolizaID            BIGINT(20);     -- POLIZA CONTABLE

-- DECLARACION DEC CONSTANTES
DECLARE Entero_Cero				INT(1);         -- Constante Entero Cero
DECLARE Constante_SI			CHAR(1);        -- Constante SI
DECLARE Constante_NO			CHAR(1);        -- Constante NO
DECLARE Cadena_Vacia			CHAR(1);        -- Constante Cadena Vacía
DECLARE Estatus_R               CHAR(1);        -- Estatus Rechazo
DECLARE Estatus_A               CHAR(1);        -- Estatus Autorizado
DECLARE Con_PagoInver           INT(11);        -- Concepto depago inversion
DECLARE Pol_Automatica          CHAR(1);        -- Constante para saber si es una poliza automatica
DECLARE Con_RefPagoInv          VARCHAR(30);    -- Variable referencia de operacion
DECLARE Estatus_Cancel          CHAR;           -- Estatus cancelado
DECLARE Act_AutorizaProceso     INT(11);        -- Autorizacion de proceso
DECLARE Act_RechazaProceso      INT(11);        -- Proceso Rechazado


-- ASIGNACION DE CONSTANTES
SET Entero_Cero                  :=	0;
SET Constante_SI                := 'S';
SET Constante_NO                := 'N';
SET Cadena_Vacia                := '';
SET Estatus_R                   := 'R';
SET Estatus_A                   := 'A';
SET Pol_Automatica              := 'A';
SET Con_PagoInver               := 15;
SET Con_RefPagoInv              := 'PAGO DE INVERSION';
SET Estatus_Cancel              := "C";
SET Act_AutorizaProceso         := 1;
SET Act_RechazaProceso          := 2;
SET Var_PolizaID                := Entero_Cero;
ManejoErrores:BEGIN

   DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									'esto le ocasiona. Ref: SP-OPERCAPITALNETOPRO');
					SET Var_Control = 'sqlException' ;
		END;

    SELECT   FechaSistema
        INTO Var_FechaSistema
    FROM PARAMETROSSIS
    WHERE EmpresaID = Aud_EmpresaID;

    SELECT FechaSucursal INTO Var_FechaSucursal
      FROM SUCURSALES
        WHERE SucursalID = Aud_Sucursal;

    IF(IFNULL(Par_OperacionID, Entero_Cero) = Entero_Cero)THEN
        SET Par_NumErr  := 001;
        SET Par_ErrMen  := 'La operacion esta vacia.';
        SET Var_Control  := 'operacionID';
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_InstrumentoID, Entero_Cero) = Entero_Cero)THEN
        SET Par_NumErr  := 002;
        SET Par_ErrMen  := 'El instrumento esta vacio.';
        SET Var_Control  := 'operacionID';
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_PantallaOrigen, Cadena_Vacia) = Cadena_Vacia)THEN
        SET Par_NumErr  := 003;
        SET Par_ErrMen  := 'El proceso esta vacio.';
        SET Var_Control  := 'pantallaOrigen';
        LEAVE ManejoErrores;
    END IF;

    IF(Par_NumAct = Act_AutorizaProceso)THEN

		IF(Par_PantallaOrigen = 'AI')THEN
			CALL INVERSIONACT(Par_InstrumentoID,        Cadena_Vacia,       Cadena_Vacia,           Constante_SI,            6,
                             Constante_NO,              Par_NumErr,			Par_ErrMen,			    Var_PolizaID,           Aud_EmpresaID,
                             Aud_Usuario,    		    Aud_FechaActual,    Aud_DireccionIP,		Aud_ProgramaID,		    Aud_Sucursal,
                             Aud_NumTransaccion);

				IF(Par_ErrMen!=Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
		END IF;

		IF(Par_PantallaOrigen = 'AC')THEN
			 CALL MAESTROPOLIZAALT(  Var_PolizaID,       Aud_EmpresaID,      Var_FechaSucursal,      Pol_Automatica,   900,
										'APERTURA CEDE',    Constante_NO,       Aud_Usuario,            Aud_FechaActual,  Aud_DireccionIP,
										Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);
				IF(Par_ErrMen!=Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

				CALL CEDESACT(Par_InstrumentoID,         Entero_Cero,       Var_PolizaID,           3,
							  Constante_NO,              Par_NumErr,		Par_ErrMen,			    Aud_EmpresaID,			Aud_Usuario,
							  Aud_FechaActual,           Aud_DireccionIP,   Aud_ProgramaID,		    Aud_Sucursal,           Aud_NumTransaccion);

				IF(Par_ErrMen!=Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
		END IF;



		UPDATE OPERCAPITALNETO
				SET EstatusOper     = Estatus_A,
					Comentario      = Par_Montivo,
					UsuarioAut      = Aud_Usuario,
					FechaAut        = Var_FechaSistema,

                    EmpresaID       = Aud_EmpresaID,
                    Usuario         = Aud_Usuario,
                    FechaActual     = Aud_FechaActual,
                    DireccionIP     = Aud_DireccionIP,
                    ProgramaID      = Aud_ProgramaID,
                    Sucursal        = Aud_Sucursal,
                    NumTransaccion  = Aud_NumTransaccion
			WHERE OperacionID = Par_OperacionID
			AND InstrumentoID = Par_InstrumentoID
			AND PantallaOrigen= Par_PantallaOrigen;
        SET Par_ErrMen := CONCAT('Operacion <b>',Par_OperacionID,'</b> Autorizada ');
    END IF;

    IF(Par_NumAct = Act_RechazaProceso)THEN

        IF(Par_PantallaOrigen = 'AI')THEN
			 UPDATE INVERSIONES SET
                Estatus         = Estatus_Cancel,
                Reinvertir      = Constante_NO,

                EmpresaID       = Aud_EmpresaID,
                Usuario         = Aud_Usuario,
                FechaActual     = Aud_FechaActual,
                DireccionIP     = Aud_DireccionIP,
                ProgramaID      = Aud_ProgramaID,
                Sucursal        = Aud_Sucursal,
                NumTransaccion  = Aud_NumTransaccion
            WHERE InversionID   = Par_InstrumentoID;
		END IF;

		IF(Par_PantallaOrigen = 'AC')THEN
			 UPDATE CEDES SET
					Estatus 		= Estatus_Cancel,
					FechaCancela 	= Var_FechaSistema,
					EmpresaID 		= Aud_EmpresaID,
					UsuarioID 		= Aud_Usuario,
					FechaActual 	= Aud_FechaActual,
					DireccionIP 	= Aud_DireccionIP,
					ProgramaID 		= Aud_ProgramaID,
					Sucursal 		= Aud_Sucursal,
					NumTransaccion 	= Aud_NumTransaccion
			WHERE 	CedeID 			= Par_InstrumentoID;
		END IF;

        IF(Par_PantallaOrigen = 'AS')THEN
			 UPDATE SOLICITUDCREDITO
                SET Estatus             = Estatus_Cancel,
                    FechaCancela		= Var_FechaSistema,
                    ComentarioEjecutivo = Par_Montivo
              WHERE SolicitudCreditoID  = Par_InstrumentoID;
		END IF;

        UPDATE OPERCAPITALNETO
            SET EstatusOper     = Estatus_R,
                Comentario      = Par_Montivo,
                UsuarioAut      = Aud_Usuario,
                FechaAut        = Var_FechaSistema,

                EmpresaID       = Aud_EmpresaID,
                Usuario         = Aud_Usuario,
                FechaActual     = Aud_FechaActual,
                DireccionIP     = Aud_DireccionIP,
                ProgramaID      = Aud_ProgramaID,
                Sucursal        = Aud_Sucursal,
                NumTransaccion  = Aud_NumTransaccion
        WHERE OperacionID = Par_OperacionID
        AND InstrumentoID = Par_InstrumentoID
        AND PantallaOrigen= Par_PantallaOrigen;

         SET Par_ErrMen := CONCAT('Operacion <b>',Par_OperacionID,'</b> Rechazada ');
    END IF;

	SET Par_NumErr	:=	0;
	SET Par_ErrMen	:=	CONCAT(Par_ErrMen, 'Exitosamente.');
    SET Var_Control := 'operacionID';


END ManejoErrores;

IF(Par_Salida = Constante_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Par_OperacionID AS Consecutivo;
END IF;


END TerminaStored$$