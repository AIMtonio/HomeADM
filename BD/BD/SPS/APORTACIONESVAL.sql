-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APORTACIONESVAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTACIONESVAL`;DELIMITER $$

CREATE PROCEDURE `APORTACIONESVAL`(
# ==============================================
# ------ SP PARA VALIDAR LOS APORTACIONES ------
# ==============================================
	Par_AportacionID		INT(11),        -- ID de la Aportacion
	Par_ProductoSAFI        INT(11),        -- Total de Productos SAFI
	Par_Salida              CHAR(1),        -- Salida en Pantalla
	INOUT Par_NumErr        INT(11),       	-- Salida en Pantalla Numero de Error o Exito
	INOUT Par_ErrMen        VARCHAR(400),   -- Salida en Pantalla Mensaje de Error o Exito

	Aud_EmpresaID           INT(11),        -- Auditoria
	Aud_Usuario             INT(11),        -- Auditoria
	Aud_FechaActual         DATETIME,       -- Auditoria
	Aud_DireccionIP         VARCHAR(15),    -- Auditoria
	Aud_ProgramaID          VARCHAR(50),    -- Auditoria

	Aud_Sucursal            INT(11),        -- Auditoria
	Aud_NumTransaccion      BIGINT(20)      -- Auditoria
)
TerminaStore: BEGIN

	-- DECLARACION DE CONSTANTES
	DECLARE Entero_Cero         INT(3);
	DECLARE Est_Inactivo        CHAR(1);
	DECLARE Salida_No           CHAR(1);
	DECLARE Salida_SI           CHAR(1);
	DECLARE SabDom              CHAR(2);
	DECLARE No_DiaHabil         CHAR(1);
	DECLARE Est_Vigente         CHAR(1);
    DECLARE Cons_AperturaFA		CHAR(2);

	-- DECLARACION DE VARIABLES
	DECLARE Var_Control         VARCHAR(200);
	DECLARE Var_ClienteID       INT(11);
	DECLARE Var_EstatusCli      CHAR(1);
	DECLARE Var_FechaInicio     DATE;
	DECLARE Var_FechaSucursal   DATE;
	DECLARE Var_TipoAportacionID	INT(11);
	DECLARE Var_PerfilAport		INT(1);
	DECLARE Var_ValTasasAport	INT(1);
	DECLARE Var_DiaInhabil      CHAR(2);
	DECLARE Var_FechaAutoriza   DATE;
	DECLARE Var_FecSal          DATE;
	DECLARE Var_EsHabil         CHAR(1);
	DECLARE Var_Estatus			CHAR(1);
	DECLARE Var_AperturaAport	CHAR(2);			-- Apertura de la aportacion FA:Fecha Actual / FP: Fecha Posterior

	-- ASIGNACION DE CONSTANTES
	SET Entero_Cero         	:= 0;       -- Constante Cero
	SET Est_Inactivo       		:= 'I';     -- Estatus Inactivo
	SET Salida_No           	:= 'N';     -- Salida No
	SET Salida_SI           	:= 'S';     -- Salida Si
	SET SabDom              	:= 'SD';    -- Dia Inhabil: Sabado y Domingo
	SET No_DiaHabil         	:= 'N';
	SET Est_Vigente        		:= 'N';     -- Estatus Vigente
	SET Var_PerfilAport      	:=  3;      -- Num Validacion
	SET Var_ValTasasAport    	:=  5;      -- Num Validacion
	SET Cons_AperturaFA			:= 'FA';	-- Apertura de la aportacion, fecha actual

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-APORTACIONESVAL');
				SET Var_Control :='SQLEXCEPTION';
			END;

		/* SE OBTIENE LA FECHA DEL SISTEMA */
		SELECT FechaSistema INTO Var_FechaAutoriza
			FROM 	PARAMETROSSIS
			WHERE 	EmpresaID	= Aud_EmpresaID;

		/* SE OBTIENEN VALORES A UTILIZAR */
		SELECT  ClienteID,          FechaInicio,        TipoAportacionID,         Estatus, AperturaAport
			INTO Var_ClienteID,     Var_FechaInicio,    Var_TipoAportacionID,     Var_Estatus, Var_AperturaAport
			FROM 	APORTACIONES
			WHERE 	AportacionID = Par_AportacionID;

        SET Var_AperturaAport := IFNULL(Var_AperturaAport,Cons_AperturaFA);

		/* SE OBTIENE EL ESTATUS DEL CLIENTE RELACIONADO A LA APORTACION */
		SELECT Cli.Estatus 	INTO Var_EstatusCli
			FROM 	CLIENTES Cli
			WHERE 	ClienteID	= Var_ClienteID;

		/* OBTENIENDO LA FECHA DE LA SUCURSAL*/
		SELECT FechaSucursal INTO Var_FechaSucursal
			FROM 	SUCURSALES
			WHERE 	SucursalID	= Aud_Sucursal;

		/* OBTENIENDO SI TIENES DIAS INHABILES SABADO Y DOMINGO */
		SELECT DiaInhabil INTO Var_DiaInhabil
			FROM 	TIPOSAPORTACIONES
			WHERE 	TipoAportacionID	= Var_TipoAportacionID;

		/* OBTENIENDO SI EL DIA ES HABIL O NO */
			IF(Var_DiaInhabil = SabDom)THEN
				CALL DIASFESTIVOSABDOMCAL(
					Var_FechaAutoriza,  Entero_Cero,        Var_FecSal,         Var_EsHabil,        Aud_EmpresaID,
					Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
					Aud_NumTransaccion  );
			END IF;

		IF(IFNULL(Par_AportacionID,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := 001;
			SET Par_ErrMen  := 'El Numero de Aportacion esta Vacio.';
			SET Var_Control := 'aportacionID' ;
			LEAVE ManejoErrores;
		END IF;

		/* SE VALIDA QUE SE TENGA UN VALOR PARA EL USUARIO QUE LANZA EL PROCESO, EXCEPTO PARA EL QUE IMPRIME EL PAGARE*/
		IF(IFNULL(Aud_Usuario, Entero_Cero) = Entero_Cero)THEN
			SET Par_NumErr  := 002;
			SET Par_ErrMen  := 'El Usuario no esta logueado.';
			SET Var_Control := 'aportacionID';
			LEAVE ManejoErrores;
		END IF;

		IF(Var_EstatusCli = Est_Inactivo) THEN
			SET Par_NumErr := 003;
			SET Par_ErrMen := CONCAT('El ',FNGENERALOCALE('safilocale.cliente'),' se Encuentra Inactivo.');
			SET Var_Control := 'aportacionID';
			LEAVE ManejoErrores;
		END IF;

		IF (DATEDIFF(Var_FechaInicio, Var_FechaSucursal)) != Entero_Cero AND Var_AperturaAport = Cons_AperturaFA THEN
			SET Par_NumErr := 004;
			SET Par_ErrMen := 'La Aportacion no es del Dia de Hoy.';
			SET Var_Control := 'aportacionID';
			LEAVE ManejoErrores;
		END IF;

		/*VALIDA QUE EL EVENTO SE ESTE REALIZANDO EN UN DIA HABIL */
		IF(Var_DiaInhabil = SabDom AND Var_EsHabil = No_DiaHabil) THEN
			SET Par_NumErr  :=  005;
			SET Par_ErrMen  :=  CONCAT('El Tipo de Aportacion ', Var_TipoAportacionID,' Tiene Parametrizado Dia Inhabil: Sabado y Domingo
										por tal Motivo No se Puede Autorizar la Aportacion.');
			SET Var_Control :=  'aportacionID';
			LEAVE ManejoErrores;
		END IF;

		IF(Var_Estatus = Est_Vigente) THEN
			SET Par_NumErr := 006;
			SET Par_ErrMen := 'La Aportacion se encuentra Autorizada.';
			SET Var_Control := 'aportacionID';
			LEAVE ManejoErrores;
		END IF;

		/*Validacion de Tasas de Ahorro */
		CALL VALIDATASASPRODUCTOS (
			Var_ClienteID,      Var_TipoAportacionID,	Par_ProductoSAFI,   Aud_Sucursal,       Var_ValTasasAport,
			Salida_No,          Par_NumErr,         	Par_ErrMen,         Aud_EmpresaID,      Aud_Usuario,
			Aud_FechaActual,    Aud_DireccionIP,    	Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			SET Var_Control := 'clienteID';
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr := 000;
		SET Par_ErrMen := 'Aportacion Validada Exitosamente';
		SET Var_Control:= 'aportacionID';

	END ManejoErrores;
		IF (Par_Salida = Salida_SI) THEN
			SELECT Par_NumErr	AS NumErr,
					Par_ErrMen  AS ErrMen,
					Var_Control AS control,
					Par_AportacionID  AS consecutivo;
		END IF;
END TerminaStore$$