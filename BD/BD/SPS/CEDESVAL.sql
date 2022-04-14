-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CEDESVAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `CEDESVAL`;DELIMITER $$

CREATE PROCEDURE `CEDESVAL`(
# ==============================================
# ---------- SP PARA VALIDAR LOS CEDES----------
# ==============================================
	Par_CedeID              INT(11),        -- ID de la Cede
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

	-- DECLARACION DE VARIABLES
	DECLARE Var_Control         VARCHAR(200);
	DECLARE Var_ClienteID       INT(11);
	DECLARE Var_EstatusCli      CHAR(1);
	DECLARE Var_FechaInicio     DATE;
	DECLARE Var_FechaSucursal   DATE;
	DECLARE Var_TipoCedeID      INT(11);
	DECLARE VarPerfilCedes      INT(1);
	DECLARE VarValTasasCedes    INT(1);
	DECLARE Var_DiaInhabil      CHAR(2);
	DECLARE Var_FechaAutoriza   DATE;
	DECLARE Var_FecSal          DATE;
	DECLARE Var_EsHabil         CHAR(1);
	DECLARE Var_EstaCede        CHAR(1);

	-- ASIGNACION DE CONSTANTES
	SET Entero_Cero         	:= 0;       -- Constante Cero
	SET Est_Inactivo       		:= 'I';     -- Estatus Inactivo
	SET Salida_No           	:= 'N';     -- Salida No
	SET Salida_SI           	:= 'S';     -- Salida Si
	SET SabDom              	:= 'SD';    -- Dia Inhabil: Sabado y Domingo
	SET No_DiaHabil         	:= 'N';
	SET Est_Vigente        		:= 'N';     -- Estatus Vigente
	SET VarPerfilCedes      	:=  3;      -- Num Validacion
	SET VarValTasasCedes    	:=  4;      -- Num Validacion

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										'esto le ocasiona. Ref: SP-CEDESVAL');
				SET Var_Control ='SQLEXCEPTION';
			END;

		/* SE OBTIENE LA FECHA DEL SISTEMA */
		SELECT FechaSistema INTO Var_FechaAutoriza
			FROM 	PARAMETROSSIS
			WHERE 	EmpresaID	= Aud_EmpresaID;

		/* SE OBTIENEN VALORES A UTILIZAR */
		SELECT  ClienteID,          FechaInicio,        TipoCedeID,         Estatus
			INTO Var_ClienteID,     Var_FechaInicio,    Var_TipoCedeID,     Var_EstaCede
			FROM 	CEDES
			WHERE 	CedeID = Par_CedeID;

		/* SE OBTIENE EL ESTATUS DEL CLIENTE RELACIONADO AL CEDE */
		SELECT Cli.Estatus 	INTO Var_EstatusCli
			FROM 	CLIENTES Cli
			WHERE 	ClienteID	= Var_ClienteID;

		/* OBTENIENDO LA FECHA DE LA SUCURSAL*/
		SELECT FechaSucursal INTO Var_FechaSucursal
			FROM 	SUCURSALES
			WHERE 	SucursalID	= Aud_Sucursal;

		/* OBTENIENDO SI TIENES DIAS INHABILES SABADO Y DOMINGO */
		SELECT DiaInhabil INTO Var_DiaInhabil
			FROM 	TIPOSCEDES
			WHERE 	TipoCedeID	= Var_TipoCedeID;

		/* OBTENIENDO SI EL DIA ES HABIL O NO */
			IF(Var_DiaInhabil = SabDom)THEN
				CALL DIASFESTIVOSABDOMCAL(
					Var_FechaAutoriza,  Entero_Cero,        Var_FecSal,         Var_EsHabil,        Aud_EmpresaID,
					Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
					Aud_NumTransaccion  );
			END IF;

		IF(IFNULL(Par_CedeID,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := 001;
			SET Par_ErrMen  := 'El Numero de Cede esta Vacio.';
			SET Var_Control := 'cedeID' ;
			LEAVE ManejoErrores;
		END IF;

		/* SE VALIDA QUE SE TENGA UN VALOR PARA EL USUARIO QUE LANZA EL PROCESO, EXCEPTO PARA EL QUE IMPRIME EL PAGARE*/
		IF(IFNULL(Aud_Usuario, Entero_Cero) = Entero_Cero)THEN
			SET Par_NumErr  := 002;
			SET Par_ErrMen  := 'El Usuario no esta logueado';
			SET Var_Control := 'cedeID';
			LEAVE ManejoErrores;
		END IF;

		IF(Var_EstatusCli = Est_Inactivo) THEN
			SET Par_NumErr := 003;
			SET Par_ErrMen :=  'El safilocale.cliente se Encuentra Inactivo';
			SET Var_Control := 'cedeID';
			LEAVE ManejoErrores;
		END IF;

		IF (DATEDIFF(Var_FechaInicio, Var_FechaSucursal)) != Entero_Cero THEN
			SET Par_NumErr := 004;
			SET Par_ErrMen := 'El CEDE no es del Dia de Hoy';
			SET Var_Control := 'cedeID';
			LEAVE ManejoErrores;
		END IF;

		/*VALIDA QUE EL EVENTO SE ESTE REALIZANDO EN UN DIA HABIL */
		IF(Var_DiaInhabil = SabDom AND Var_EsHabil = No_DiaHabil) THEN
			SET Par_NumErr  :=  005;
			SET Par_ErrMen  :=  CONCAT('El Tipo de CEDE ', Var_TipoCedeID,' Tiene Parametrizado Dia Inhabil: Sabado y Domingo
										por tal Motivo No se Puede Autorizar el CEDE.');
			SET Var_Control :=  'cedeID';
			LEAVE ManejoErrores;
		END IF;

		IF(Var_EstaCede = Est_Vigente) THEN
			SET Par_NumErr := 006;
			SET Par_ErrMen := 'El CEDE se encuentra Autorizado';
			SET Var_Control := 'cedeID';
			LEAVE ManejoErrores;
		END IF;

		CALL VALPRODUCPERFIL(
				Var_ClienteID,      Var_TipoCedeID,      	VarPerfilCedes,    	Salida_No,          	Par_NumErr,
				Par_ErrMen,         Aud_EmpresaID,          Aud_Usuario,      	Aud_FechaActual,    	Aud_DireccionIP,
				Aud_ProgramaID,     Aud_Sucursal,           Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			SET Var_Control := 'clienteID';
			LEAVE ManejoErrores;
		END IF;

		/*Validacion de Tasas de Ahorro */
		CALL VALIDATASASPRODUCTOS (
			Var_ClienteID,      Var_TipoCedeID,    	Par_ProductoSAFI,   Aud_Sucursal,       VarValTasasCedes,
			Salida_No,          Par_NumErr,         Par_ErrMen,         Aud_EmpresaID,      Aud_Usuario,
			Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			SET Var_Control := 'clienteID';
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr := 000;
		SET Par_ErrMen := 'CEDE Validada Exitosamente';
		SET Var_Control:= 'cedeID';

	END ManejoErrores;
		IF (Par_Salida = Salida_SI) THEN
			SELECT Par_NumErr	AS NumErr,
					Par_ErrMen  AS ErrMen,
					Var_Control AS control,
					Par_CedeID  AS consecutivo;
		END IF;
END TerminaStore$$