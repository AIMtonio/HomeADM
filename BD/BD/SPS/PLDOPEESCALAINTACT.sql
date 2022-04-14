
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDOPEESCALAINTACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDOPEESCALAINTACT`;

DELIMITER $$
CREATE PROCEDURE `PLDOPEESCALAINTACT`(
/* SP QUE ACTUALIZA UNA SOLICITUD DE ESCALAMIENTO INTERNO */
    Par_OperProcID      BIGINT(12),				-- ID de la operacion de escalamiento
    Par_NombreProc      VARCHAR(16),			-- Nombre del Proceso de escalamiento
    Par_TipResEscID     CHAR(1),				-- Tipo de Resultado del escalamiento
    Par_CveJustif       INT,					-- Clave de justificacion del escalamiento
    Par_FechRealiza     DATETIME,				-- Fecha de actualizacion

    Par_CFuncionar      INT,					-- ID del usuario funcionario
    Par_NotasRevisor    VARCHAR(1500),			-- Notas del Revisor
    Par_SolSeguimiento  CHAR(1),				-- S.- Si solicita seguimiento, N.- No solicita seguimiento
    Par_TipoAct         INT(11),                -- Tipo de Actualizacion
    Par_Salida          CHAR(1),				-- Indica si el procedimiento regresa una salida

    INOUT Par_NumErr  	INT(11),				-- Numero de Error
    INOUT Par_ErrMen  	VARCHAR(400),			-- Mensaje de Error
    /* Parametros de Auditoria */
    Par_EmpresaID       INT,
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,

    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
	)
TerminaStore: BEGIN

-- Declaracion de variables
DECLARE Var_Resultado	   CHAR(1);

-- Declaracion de constantes
DECLARE	Cadena_Vacia    CHAR(1);
DECLARE	Fecha_Vacia     DATE;
DECLARE	Entero_Cero     INT;
DECLARE	Esta_Autorizado CHAR(1);
DECLARE	Esta_Rechazado  CHAR(1);
DECLARE	Act_Estatus     INT;
DECLARE	SalidaSI        CHAR(1);
DECLARE	SalidaNO        CHAR(1);

-- Asignacion  de constantes
SET	Cadena_Vacia    := '';				-- Cadena vacia
SET	Fecha_Vacia     := '1900-01-01';	-- Fecha vacia
SET	Entero_Cero     := 0;				-- Entero cero
SET	Esta_Autorizado := 'A';             -- Estatus de Autorizada
SET	Esta_Rechazado  := 'R';             -- Estatus de Rechazado
SET	Act_Estatus     := 1;               -- Actualizacion de Respuesta de la Operacion
SET	SalidaSI        := 'S';				-- Salida SI
SET	SalidaNO        := 'N'; 			-- Salida NO

SET Aud_FechaActual := NOW();
SET Par_FechRealiza := NOW();

ManejoErrores: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		SET Par_NumErr := 999;
		SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-PLDOPEESCALAINTACT');
    END;

    /* Actualizacion de Respuesta o Estatus */
    IF(Par_TipoAct = Act_Estatus ) THEN

        SELECT TipoResultEscID INTO Var_Resultado
            FROM PLDOPEESCALAINT
            WHERE OperProcesoID = Par_OperProcID
              AND ProcesoEscID  = Par_NombreProc;

        SET Var_Resultado := IFNULL(Var_Resultado, Cadena_Vacia);

        IF(Var_Resultado = Cadena_Vacia) THEN
            SET	Par_NumErr := 1;
            SET	Par_ErrMen := "La Operacion de Escalamiento no Existe";
            LEAVE ManejoErrores;
        END IF;

        IF(Var_Resultado = Esta_Autorizado OR Var_Resultado = Esta_Rechazado) THEN
            SET	Par_NumErr := 2;
            SET	Par_ErrMen := "La Operacion no Puede ser Actualizada. Esta Autorizada o Rechazada";
            LEAVE ManejoErrores;
        END IF;

        UPDATE PLDOPEESCALAINT SET
            TipoResultEscID     = Par_TipResEscID,
            ClaveJustEscIntID   = Par_CveJustif,
            FechRealizacion     = Par_FechRealiza,
            CveFuncionario      = Par_CFuncionar,
            NotasRevisor        = Par_NotasRevisor,
            SolSeguimiento      = Par_SolSeguimiento,

            Usuario             = Aud_Usuario,
            FechaActual         = Aud_FechaActual,
            DireccionIP         = Aud_DireccionIP,
            ProgramaID          = Aud_ProgramaID,
            Sucursal            = Aud_Sucursal,
            NumTransaccion      = Aud_NumTransaccion

        WHERE OperProcesoID = Par_OperProcID
          AND ProcesoEscID  = Par_NombreProc;

		IF(Par_TipResEscID = Esta_Autorizado)THEN
			CALL PLDALERTASESCINTPRO(
				3,					0,				Par_OperProcID,	Par_NombreProc,		SalidaNO,
				Par_NumErr,			Par_ErrMen,		Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);
		END IF;

        SET	Par_NumErr := 0;
        SET	Par_ErrMen := CONCAT("Informacion Actualizada para la Operacion: ",Par_OperProcID);

    END IF; -- END del Tipo de Actualizacion por Estatus

END ManejoErrores;  -- En del Handler de Errores

 IF(IFNULL(Par_Salida,SalidaNO) = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            'folioOperacionID' AS Control,
            Par_OperProcID AS Consecutivo;
 END IF;

END TerminaStore$$

