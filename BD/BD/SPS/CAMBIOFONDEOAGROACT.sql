-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CAMBIOFONDEOAGROACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CAMBIOFONDEOAGROACT`;
DELIMITER $$

CREATE PROCEDURE `CAMBIOFONDEOAGROACT`(
# =======================================================================
# ------- STORE PARA ACTUALIZACION DE CREDITOS---------
# =======================================================================
	Par_CreditoID       BIGINT(12),			-- Id del credito
  	Par_LineaFondeoID   INT(11),			-- Linea de Fondeo, corresponde con la tabla LINEAFONDEADOR
	Par_InstitutFondID	INT(11),			-- id de institucion de fondeo corresponde con la tabla INSTITUTFONDEO
    Par_NumAct          TINYINT UNSIGNED,	-- Numero de Actualizacion

    Par_Salida          CHAR(1),			-- indica una salida
    INOUT Par_NumErr    INT(11),            -- parametro numero de erro
    INOUT Par_ErrMen    VARCHAR(400),       -- mensaje de error

    Par_EmpresaID       INT(11),            -- parametros de auditoria
    Aud_Usuario	        INT(11),            -- parametros de auditoria
    Aud_FechaActual     DATETIME,           -- parametros de auditoria
    Aud_DireccionIP     VARCHAR(15),        -- parametros de auditoria
    Aud_ProgramaID      VARCHAR(50),        -- parametros de auditoria
    Aud_Sucursal        INT(11),            -- parametros de auditoria
    Aud_NumTransaccion  BIGINT(20)          -- parametros de auditoria
)
TerminaStore: BEGIN
    /* Declaracion de Constantes */
    DECLARE Cadena_Vacia		CHAR(1);          -- Constante Cadena Vacia
    DECLARE Fecha_Vacia			DATE;             -- Constante Fecha Vacia
    DECLARE Act_FuenteFondeo	INT;              -- Constante Actualiza Fuente de Fondeo
    DECLARE SalidaNO            CHAR(1);          -- Constante Salida NO
    DECLARE SalidaSI            CHAR(1);          -- Constante Salida SI
    DECLARE Entero_Cero			INT;              -- Constante Entero Cero
    DECLARE Decimal_Cero        DECIMAL(12,2);    -- Constante Decimal Cero
    DECLARE RecursoFondeador    CHAR(1);          -- Constante Recurso Fondeador
    DECLARE RecursoPropio       CHAR(1);          -- Constante Recurso Propio

    -- Declaracion de variables
	DECLARE Var_Solictud         INT(11);         -- Solicitud de Credito ID
    DECLARE Var_CreditoID		 BIGINT(12);      -- Credito ID
    DECLARE Var_CuentaID		 BIGINT(12);      -- Cuenta Ahorro ID
    DECLARE Var_FechaSistema	 DATE;            -- Fecha de Sistema
    DECLARE Var_Consecutivo      BIGINT(20);      -- Numero de Consecutivo
    DECLARE Var_Control			 VARCHAR(100);    -- Control de Retorno en Pantalla
    DECLARE Var_Estatus			 CHAR(1);         -- Estatus del Credito
    DECLARE Var_RecursoFondeador CHAR(1);         -- Valor del Recurso Fondeador

    -- Asignacion de Constantes
    SET Cadena_Vacia        := '';
    SET Fecha_Vacia         := '1900-01-01';
    SET Entero_Cero         := 0;
    SET SalidaSI            := 'S';
    SET SalidaNO            := 'N';
    SET Decimal_Cero        := 0.0;
    SET Act_FuenteFondeo	:= 1;
    SET RecursoFondeador	:= 'F';
    SET RecursoPropio       := 'P';

ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET Par_NumErr := 999;
            SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al
									concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-CAMBIOFONDEOAGROACT');
            SET Var_Control := 'SQLEXCEPTION' ;
        END;

	-- Se obtiene la Solicitud del credito
    SELECT  CreditoID,		Estatus,		SolicitudCreditoID
    		INTO
    		Var_CreditoID,	Var_Estatus,	Var_Solictud
        FROM CREDITOS
        WHERE CreditoID = Par_CreditoID;

    SET Var_Estatus := IFNULL(Var_Estatus, Cadena_Vacia);

    -- Actualiza fuente de fondeador
    IF(Par_NumAct = Act_FuenteFondeo)THEN

        SET Var_RecursoFondeador := RecursoFondeador;
        IF( Par_InstitutFondID = Entero_Cero AND Par_LineaFondeoID = Entero_Cero ) THEN
            SET Var_RecursoFondeador := RecursoPropio;
        END IF;

        -- Actualiza en creditos
		UPDATE CREDITOS SET
			TipoFondeo		= Var_RecursoFondeador,
			InstitFondeoID  = Par_InstitutFondID,
			LineaFondeo		= Par_LineaFondeoID,

			EmpresaID       = Par_EmpresaID,
			Usuario         = Aud_Usuario,
			FechaActual     = Aud_FechaActual,
			DireccionIP     = Aud_DireccionIP,
			ProgramaID      = Aud_ProgramaID,
			Sucursal        = Aud_Sucursal,
			NumTransaccion  = Aud_NumTransaccion
		WHERE CreditoID = Par_CreditoID;


        SET Par_NumErr      :=  Entero_Cero;
        SET Par_ErrMen      := 'Credito Actualizado Exitosamente.';
        SET Var_Control     := 'creditoID';
        SET Var_Consecutivo :=  Par_CreditoID;

    END IF;

END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
        SELECT  Par_NumErr          AS Par_NumErr,
                Par_ErrMen          AS ErrMen,
                Var_Control         AS control,
                Var_Consecutivo     AS consecutivo;
    END IF;

END TerminaStore$$