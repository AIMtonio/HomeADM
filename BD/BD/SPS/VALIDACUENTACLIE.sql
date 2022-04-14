-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- VALIDACUENTACLIE
DELIMITER ;
DROP PROCEDURE IF EXISTS `VALIDACUENTACLIE`;DELIMITER $$

CREATE PROCEDURE `VALIDACUENTACLIE`(
	Par_ClienteID		          INT(11),			-- ClienteID a Validar.
	Par_TipoCuentaID	          INT(11),			-- Id tipo de cuenta.
	Par_CuentaAhoID	              BIGINT(12),		-- Id cuenta ahorro.
	Par_Salida    		          CHAR(1), 			-- Indica Mensaje de Salida(S= Si, N=No).
	INOUT	Par_NumErr 	          INT(11),			-- INOUT Numero de Error.

	INOUT	Par_ErrMen            VARCHAR(400),		-- INOUT Mensaje de Error.
	Par_EmpresaID		          INT(11),			-- Parametro de Auditoria.
	Aud_Usuario			          INT(11),			-- Parametro de Auditoria.
	Aud_FechaActual		          DATETIME,			-- Parametro de Auditoria.
	Aud_DireccionIP		          VARCHAR(15),		-- Parametro de Auditoria.

	Aud_ProgramaID		          VARCHAR(50),		-- Parametro de Auditoria.
	Aud_Sucursal		          INT(11),			-- Parametro de Auditoria.
	Aud_NumTransaccion            BIGINT(20)		-- Parametro de Auditoria.
)
TerminaStore : BEGIN
-- Declaracion de Constantes.
DECLARE SalidaNO			      CHAR(1);
DECLARE	SalidaSI			      CHAR(1);
DECLARE	Entero_Cero				  INT(1);
DECLARE CadenaVacia				  CHAR(1);
DECLARE No_Oficial			      CHAR(1);
DECLARE Si					      CHAR(1);
DECLARE Var_NoConociCte		      INT(11);
DECLARE Var_NoConociCta		      BIGINT(12);
DECLARE Menor_No			      CHAR(1);
DECLARE InstruCuentas             INT;

-- Declaracion de Variables.
DECLARE Var_DireccionOficial	    CHAR(1);            -- Si el tipo de cuenta requiere Direccion oficial.
DECLARE Var_IdenOficial	            CHAR(1);            -- Si el tipo de cuenta requiere Identificacion Oficial.
DECLARE Var_ConCuenta               CHAR(1);            -- Si el tipo de cuenta requiere ConCuenta.
DECLARE Var_CheckListExpFisico	    CHAR(1);            -- Si el tipo de cuenta requiere CheckListExpFisico.
DECLARE Var_RelacionadoCuenta	    CHAR(1);		    -- Si el tipo de cuenta requiere RelacionadoCuenta
DECLARE Var_RegistroFirmas		    CHAR(1);			-- Si el tipo de cuenta requiere RegistroFirmas.
DECLARE Var_HuellasFirmante		    CHAR(1);		    -- Si el tipo de cuenta requiere HuellasFirmante.

DECLARE Var_DirOfiCli	            CHAR(1);            -- Direccion oficial del cliente.
DECLARE Var_IdenOfiCli              CHAR(1);            -- Identificacion Oficial del cliente.
DECLARE Var_RelCtaCli               BIGINT(12);		    -- RelacionadoCuenta del cliente.
DECLARE Var_RegistroFirmasCli	    BIGINT(12);			-- RegistroFirmas del cliente.
DECLARE Var_FuncionHuella           CHAR(1);            -- Si el sistema permite funcion huella.
DECLARE Var_ReqHuellaProductos      CHAR(1);            -- Si el sistema requiere huella para los productos
DECLARE Var_PersonaID               INT(11);            -- ID de la persona
DECLARE AplicadoSi                  CHAR(1);            -- Si se tiene aplicado el documento
DECLARE Tipo_Cliente                CHAR(1);            -- Tipo cliente
DECLARE Var_EsMenorEdad		        CHAR(1);            -- Si es menor de edad
DECLARE Var_TipoPersona 	        CHAR(1);            -- Variable tipo persona
DECLARE Var_Control 	        	VARCHAR(20);		-- Variable control
DECLARE Var_SolicitaPerfil 	        	VARCHAR(1);		-- Variable control

-- Asignacion de Contantes.
SET SalidaSI	      		:='S';					    -- Constante Salida SI.
SET	SalidaNO				:='N';                      -- Constante Salida NO.
SET Entero_Cero			    :=0;						-- Constante Entero Cero.
SET CadenaVacia			    :='';						-- Constante Cadena Vacia.
SET No_Oficial				:='N';                      -- Constante valida NO oficial.
SET Si						:='S';                      -- Constante valida SI oficial.
SET Tipo_Cliente            :='C';                      -- Constante tipo cliente
SET AplicadoSi              :='S';                      -- Constante aplicado si
SET InstruCuentas           := 2;                       -- instrumento cuentas
SET Menor_No                :='N';                      -- Constante es menor no
-- Asignacion de Variables.
SET Par_NumErr		      := 0;                         -- Numero de error
SET Par_ErrMen		      := '';                        -- Mensaje de error


ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
		SET Par_NumErr := 999;
		SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-VALIDACUENTACLIE');
		SET Var_Control := 'SQLEXCEPTION' ;
	END;

	SELECT
		Cli.EsMenorEdad
	INTO
		Var_EsMenorEdad
	FROM CLIENTES Cli INNER JOIN CUENTASAHO Cue ON Cue.ClienteID=Cli.ClienteID
		WHERE CuentaAhoID = Par_CuentaAhoID;

	SET Var_EsMenorEdad	:= IFNULL(Var_EsMenorEdad, Menor_No);

	-- si el cliente tiene idenfificacion oficial
	SELECT
		ide.Oficial
	INTO
		Var_IdenOfiCli
	FROM IDENTIFICLIENTE ide
		INNER JOIN CLIENTES cli ON cli.ClienteID = ide.ClienteID
		WHERE ide.ClienteID = Par_ClienteID
			AND ide.Oficial = Si
			AND cli.EsMenorEdad = Menor_No
		LIMIT 1;
	SET Var_IdenOfiCli  :=IFNULL(Var_IdenOfiCli , No_Oficial);

	-- si el cliente tiene direccion oficial
	SELECT
		dir.Oficial
	INTO
		Var_DirOfiCli
	FROM DIRECCLIENTE dir
		WHERE dir.ClienteID = Par_ClienteID
			AND dir.Oficial = Si;
	SET Var_DirOfiCli :=IFNULL(Var_DirOfiCli,No_Oficial);

	-- si  el cliente tiene conocimiento solo para mayores de edad
	SELECT
		c.ClienteID
	INTO
		Var_NoConociCte
	FROM CONOCIMIENTOCTE c
		WHERE c.ClienteID = Par_ClienteID;
	SET Var_NoConociCte:= IFNULL(Var_NoConociCte, Entero_Cero);

	--  Si la cuenta tiene conocimiento
	SELECT
		cta.CuentaAhoID
	INTO
		Var_NoConociCta
	FROM CONOCIMIENTOCTA cta
		WHERE cta.CuentaAhoID = Par_CuentaAhoID;
	SET Var_NoConociCta :=IFNULL(Var_NoConociCta,Entero_Cero);


	--  Si la cuenta tiene relacionados
	SELECT
		cta.CuentaAhoID
	INTO
		Var_RelCtaCli
	FROM CUENTASPERSONA cta
		WHERE cta.CuentaAhoID = Par_CuentaAhoID
	LIMIT 1;
	SET Var_RelCtaCli  :=IFNULL(Var_RelCtaCli ,Entero_Cero);

	--  Si la cuenta tiene Firmantes
	SELECT
		cta.CuentaAhoID
	INTO
		Var_RegistroFirmasCli
	FROM CUENTASFIRMA cta
		WHERE cta.CuentaAhoID = Par_CuentaAhoID
	LIMIT 1;
	SET Var_RegistroFirmasCli :=IFNULL(Var_RegistroFirmasCli, Entero_Cero);

	--  Si la cuenta tiene Huella Digital
	SELECT
		huell.TipoPersona,	huell.PersonaID
	INTO
		Var_TipoPersona,	Var_PersonaID
	FROM HUELLADIGITAL huell
		WHERE huell.PersonaID = Par_ClienteID
			AND huell.TipoPersona = Tipo_Cliente
		LIMIT 1;
	SET Var_PersonaID :=IFNULL(Var_PersonaID, Entero_Cero);


	-- se consultan los requerimientos para la activacion de la cuenta
	SELECT
		tip.DireccionOficial,	tip.IdenOficial,		tip.ConCuenta,		tip.CheckListExpFisico,
		tip.RelacionadoCuenta,	tip.RegistroFirmas,		tip.HuellasFirmante
	INTO
		Var_DireccionOficial,	Var_IdenOficial,		Var_ConCuenta,		Var_CheckListExpFisico,
		Var_RelacionadoCuenta,	Var_RegistroFirmas,		Var_HuellasFirmante
	FROM CUENTASAHO cue
		INNER JOIN TIPOSCUENTAS tip ON cue.TipoCuentaID = tip.TipoCuentaID
		WHERE CuentaAhoID = Par_CuentaAhoID
			AND cue.TipoCuentaID = tip.TipoCuentaID
		LIMIT 1;

	SELECT
		FuncionHuella,		ReqHuellaProductos
	INTO
		Var_FuncionHuella,	Var_ReqHuellaProductos
	FROM PARAMETROSSIS;

	IF (Var_DireccionOficial=Si)THEN
		IF(Var_DirOfiCli = No_Oficial)THEN
			SET Par_NumErr :=001;
			SET Par_ErrMen :=CONCAT('El ',FNSAFILOCALECTE(),' No Tiene una Direccion Oficial.');
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF (Var_IdenOficial=Si)THEN
		IF(Var_IdenOfiCli  = No_Oficial AND Var_EsMenorEdad = Menor_No) THEN
			SET Par_NumErr :=002;
			SET Par_ErrMen :=CONCAT('El ',FNSAFILOCALECTE(),' No Tiene una Identificacion Oficial.');
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF (Var_ConCuenta = Si) THEN
		IF (Var_EsMenorEdad = Menor_No) THEN
			IF(Var_NoConociCte = Entero_Cero)THEN
				SET Par_NumErr :=003;
				SET Par_ErrMen :=CONCAT('No Existe Conocimiento del ',FNSAFILOCALECTE(),'.');
				LEAVE ManejoErrores;
			END IF;
		END IF;
	END IF;


	IF (Var_ConCuenta = Si) THEN
		IF(Var_NoConociCta = Entero_Cero)THEN
			SET Par_NumErr :=004;
			SET Par_ErrMen :='No Existe Conocimiento de la Cuenta.';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF (Var_RelacionadoCuenta = Si) THEN
		IF(Var_RelCtaCli = Entero_Cero)THEN
			SET Par_NumErr :=005;
			SET Par_ErrMen :='No Existen Relacionados de la Cuenta.';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF (Var_RegistroFirmas = Si) THEN
		IF(Var_RegistroFirmasCli = Entero_Cero)THEN
			SET Par_NumErr :=006;
			SET Par_ErrMen :='No Existen Firmas Autorizadas de la Cuenta.';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(Var_FuncionHuella  = Si)THEN
		IF(Var_ReqHuellaProductos = Si)THEN
			IF (Var_HuellasFirmante = Si) THEN
				IF(Var_PersonaID = Entero_Cero)THEN
					SET Par_NumErr :=007;
					SET Par_ErrMen :=CONCAT('No Existe Registro de Huella digital del ',FNSAFILOCALECTE(),'.');
					LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF;
	END IF;
	SET Var_SolicitaPerfil := (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = 'PerfilTransaccionObliga');
	IF(Var_SolicitaPerfil = 'S')THEN
		IF(NOT EXISTS(SELECT * FROM PLDPERFILTRANS WHERE ClienteID = Par_ClienteID))THEN
			SET Par_NumErr := 008;
			SET Par_ErrMen := CONCAT('No Existe Perfil Transaccional del ',FNSAFILOCALECTE(),'.');
			LEAVE ManejoErrores;
		END IF;
	END IF;

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT
			CONVERT(Par_NumErr, CHAR(10)) AS NumErr,
			Par_ErrMen AS ErrMen;
	END IF;

END TerminaStore$$