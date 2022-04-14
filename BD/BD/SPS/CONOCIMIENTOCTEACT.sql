
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------

-- CONOCIMIENTOCTEACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONOCIMIENTOCTEACT`;

DELIMITER $$
CREATE PROCEDURE `CONOCIMIENTOCTEACT`(
	/*SP para la modificacion del conocimiento del cliente*/
	Par_ClienteID			INT(11),				-- Número de Cliente.
	Par_NumAct				TINYINT,				-- Número de Actualización.
	Par_NomGrupo			VARCHAR(100),			-- En caso de pertenecer a una sociedad, grupo o filial                                                                                                                  
	Par_RFC					VARCHAR(13),			-- En caso de pertenecer a una sociedad, grupo o filial                                                                                                                       
	Par_Participacion		DECIMAL(14,2),			-- En caso de pertenecer a una sociedad, grupo o filial                                                                                                             

	Par_Nacionalidad		VARCHAR(45),			-- En caso de pertenecer a una sociedad, grupo o filial
	Par_RazonSocial			VARCHAR(100),			-- En caso de tener actividad empresarial
	Par_Giro				VARCHAR(100),			-- En caso de tener actividad empresarial
	Par_PEPs				CHAR(1),				-- Persona politicamente expuesta, aque individuo que desempeña o ha desempeñado funciones publicas destacadas en un pais extrajero o territorio nacional Valor: S =Si N= No
	Par_FuncionID			INT(11),				-- Id de la Función Pública. FUNCIONESPUB.

	Par_ParentescoPEP		CHAR(1),				-- Indica si tiene parentezco PEP.
	Par_NombFam				VARCHAR(50),			-- Nombre del familiar PEP.
	Par_aPaternoFam			VARCHAR(50),			-- Apellido Paterno del familiar PEP.
	Par_aMaternoFam			VARCHAR(50),			-- Apellido Materno del familiar PEP.
	Par_NoEmpleados			CHAR(10),

	Par_Serv_Produc			VARCHAR(50),
	Par_CoberGeograf		CHAR(1),				-- Cobertura geográfica: L=Local E=Estatal R=Regional N=Nacional I=Internacional
	Par_Edos_Presen			VARCHAR(45),
	Par_ImporteVta			DECIMAL(14,2),
	Par_Activos				DECIMAL(14,2),

	Par_Pasivos				DECIMAL(14,2),
	Par_Capital				DECIMAL(14,2),
	Par_Importa				CHAR(1),				-- Valores Si=S No=N
	Par_DolImport			CHAR(5),				-- valores: menos1000:DImp 1,001 a 5,000:DImp2 5,001 a 10,000:DImp3 Mayores 10,001DImp4
	Par_PaisImport			VARCHAR(50),

	Par_PaisImport2			VARCHAR(50),
	Par_PaisImport3   		VARCHAR(50),
	Par_Exporta     		CHAR(1),				-- Valores Si=S No=N
	Par_DolExport   		CHAR(5),				-- valores: menos1000:DExp 1,001 a 5,000: DExp2 5,001 a 10,000: DExp3 mayor10001:DExp4
	Par_PaisExport    		VARCHAR(50),

	Par_PaisExport2   		VARCHAR(50),
	Par_PaisExport3   		VARCHAR(50),
	Par_NombRefCom    		VARCHAR(50),
	Par_NombRefCom2   		VARCHAR(50),
	Par_TelRefCom   		VARCHAR(20),

	Par_TelRefCom2    		VARCHAR(20),
	Par_BancoRef    		VARCHAR(45),
	Par_BancoRef2   		VARCHAR(45),
	Par_NoCtaRef    		VARCHAR(30),			-- Referencias Bancarias
	Par_NoCtaRef2   		VARCHAR(30),			-- Referencias Bancarias

	Par_NombreRef   		VARCHAR(50),			-- Referencias que no vivan en su domicilio
	Par_NombreRef2    		VARCHAR(50),			-- Referencias que no vivan en su domicilio
	Par_DomRef      		VARCHAR(150),			-- Referencias que no vivan en su domicilio
	Par_DomRef2     		VARCHAR(150),			-- Referencias que no vivan en su domicilio
	Par_TelRef      		VARCHAR(20),			-- Referencias que no vivan en su domicilio

	Par_TelRef2     		VARCHAR(20),			-- Referencias que no vivan en su domicilio
	Par_pFteIng     		VARCHAR(100),			-- Principal Fuente de Ingresos
	Par_IngAproxMes   		VARCHAR(10),			-- Principal Fuente de Ingresos
	Par_ExtTelRef1    		VARCHAR(6),				-- Contiene el número de extension del telefono (Primer Referencia)
	Par_ExtTelRef2    		VARCHAR(6),				-- Contiene el numero de extensión de teléfono (Segunda Referencia)

	Par_ExtTelRefCom  		VARCHAR(6),				-- Contiene el número de extensión de telefono de referencia comercial
	Par_ExtTelRefCom2 		VARCHAR(6),				-- Contiene el número de extensión de telefono de referencia comercial
	Par_Relacion1   		INT,					-- ID de Tipo relacion del Cliente
	Par_Relacion2   		INT,					-- ID de Tipo relacion del Cliente
	Par_PregUno     		VARCHAR(100),			-- Primer pregunta al Cliente en caso de que se trate de Riesgo Alto.

	Par_RespUno     		VARCHAR(200),			-- Primer respuesta del Cliente en caso de que se trate de Riesgo Alto.
	Par_PregDos     		VARCHAR(100),			-- Segunda pregunta al Cliente en caso de que se trate de Riesgo Alto.
	Par_RespDos     		VARCHAR(200),			-- Segunda respuesta del Cliente en caso de que se trate de Riesgo Alto.
	Par_PregTres    		VARCHAR(100),			-- Tercer pregunta al Cliente en caso de que se trate de Riesgo Alto.
	Par_RespTres    		VARCHAR(200),			-- Tercer respuesta del Cliente en caso de que se trate de Riesgo Alto.

	Par_PregCuatro    		VARCHAR(100),			-- Cuarta pregunta al Cliente en caso de que se trate de Riesgo Alto.
	Par_RespCuatro    		VARCHAR(200),			-- Cuarta respuesta del Cliente en caso de que se trate de Riesgo Alto.
	Par_CapitalContable 	DECIMAL(14,2),			-- Capital Contable.
	Par_NivelRiesgo			CHAR(1),
	Par_EvaluaXMatriz		CHAR(1),				-- Evalua o no en la matriz de riesgos.

	Par_ComentarioNivel	VARCHAR(200),
	Par_NoCuentaRefCom		VARCHAR(50),		-- Numero de cuenta de la referencia comercial
	Par_NoCuentaRefCom2		VARCHAR(50),		-- Numero de cuenta de la segunda referencia comercial
	Par_DireccionRefCom		VARCHAR(500),		-- Direccion de la referencia comercial
	Par_DireccionRefCom2	VARCHAR(500),		-- Direccion de la segunda referencia comercial

	Par_BanTipoCuentaRef	VARCHAR(50),		-- Tipo de cuenta de la referencia comercial bancaria
	Par_BanTipoCuentaRef2	VARCHAR(50),		-- Tipo de cuenta de la segunda referencia comercial bancaria
	Par_BanSucursalRef		VARCHAR(50),		-- Sucursal de la referencia comercial bancaria
	Par_BanSucursalRef2		VARCHAR(50),		-- Sucursal de la segunda referencia comercial bancaria
	Par_BanNoTarjetaRef		VARCHAR(50),		-- Numero de tarjeta de la referencia comercial bancaria

	Par_BanNoTarjetaRef2	VARCHAR(50),		-- Numero de tarjeta de la segunda referencia comercial bancaria
	Par_BanTarjetaInsRef	VARCHAR(50),		-- Institucion de la tarjeta de la referencia comercial bancaria
	Par_BanTarjetaInsRef2	VARCHAR(50),		-- Institucion de la tarjeta de la segunda referencia comercial bancaria
	Par_BanCredOtraEnt		CHAR(1),			-- Indica si la referencia comercial bancaria tiene o no un credito con otra entidad
	Par_BanCredOtraEnt2		CHAR(1),			-- Indica si la segunda referencia comercial bancaria tiene o no un credito con otra entidad

	Par_BanInsOtraEnt		VARCHAR(50),		-- Institucion con la que la referencia comercial bancaria tiene otro credito
	Par_BanInsOtraEnt2		VARCHAR(50),		-- Institucion con la que la segunda referencia comercial bancaria tiene otro credito
	Par_FechaNombramiento	DATE,				-- Fecha de Nombramiento en caso de PEPs > Parametro para Cuestionarios Adicionales
	Par_PeriodoCargo		VARCHAR(100),		-- Periodo del cargo en caso de PEPs > Parametro para Cuestionarios Adicionales
	Par_PorcentajeAcciones	DECIMAL(10,2),		-- Porcentaje de Acciones en caso de PEPs > Parametro para Cuestionarios Adicionales

	Par_MontoAcciones		DECIMAL(12,2),		-- Monto de las acciones en caso de PEPs > Parametro para Cuestionarios Adicionales
	Par_TiposClientes			CHAR(1),		-- Tipos de Clientes F) Persona Fisica M) Persona Moral > Parametro para Cuestionarios Adicionales.
	Par_InstMonetarios 			CHAR(1),			-- Instrumentos monetarios E) Efectivo C) Cheque T) > Transferencia\nParametro para Cuestionarios Adicionales.
	Par_OperacionAnios			INT(11),		-- Indica los años de la operacion de cliente
	Par_GiroAnios				INT(11),		-- Indica los años del giro de la operacion del cliente

	Par_Salida          		CHAR(1),		-- SI o NO Saldia
	INOUT Par_NumErr  		INT(11),			-- Numero de Error
	INOUT Par_ErrMen  		VARCHAR(400),		-- Mensaje de Error
	Aud_EmpresaID   		INT,
	Aud_Usuario     		INT,

	Aud_FechaActual  		DATETIME,
	Aud_DireccionIP   		VARCHAR(15),
	Aud_ProgramaID   		VARCHAR(50),
	Aud_Sucursal    		INT,
	Aud_NumTransaccion  	BIGINT
)
TerminaStore: BEGIN

-- Declaracion de variables
DECLARE Var_Control				VARCHAR(50);
DECLARE Var_ClienteID			INT(11);
DECLARE Var_AltaConocimiento	CHAR(1);

-- Declaracion de constantes
DECLARE Entero_Cero				INT;
DECLARE Cadena_Vacia			CHAR(1);
DECLARE Fecha_Vacia				DATE;
DECLARE Cons_Si					CHAR(1);
DECLARE Cons_No					CHAR(1);
DECLARE Act_PEPSi				INT(11);
DECLARE Alta_ConocimientoCTE	INT(11);

-- Asignacion de constantes
SET Entero_Cero					:= 0;				# Entero en Cero.
SET Cadena_Vacia				:= '';				# Cadena o String Vacio.
SET Fecha_Vacia					:= '1900-01-01';	# Fecha Vacia.
SET Cons_Si						:= 'S';				# Constante SI.
SET Cons_No						:= 'N';				# Constante NO.
SET Act_PEPSi					:= 1;				# Actualización PEP.
SET Alta_ConocimientoCTE		:= 3;				# Alta Conocimiento del Cliente.

ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
		SET Par_NumErr := 999;
		SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CONOCIMIENTOCTEACT');
		SET Var_Control := 'sqlException';
	END;

	IF(Par_NumAct = Act_PEPSi)THEN
		IF(IFNULL(Par_ClienteID, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := CONCAT('El ',FNGENERALOCALE('safilocale.cliente'),' se Encuentra Vacio.');
			SET Var_Control := 'clienteID';
			LEAVE ManejoErrores;
		END IF;

		IF(NOT(EXISTS(SELECT * FROM CLIENTES WHERE ClienteID = Par_ClienteID))) THEN
			SET Par_NumErr := 2;
			SET Par_ErrMen := CONCAT('El ',FNGENERALOCALE('safilocale.cliente'),' No Existe.');
			SET Var_Control := 'clienteID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_PEPs, Cadena_Vacia) NOT IN (Cons_Si,Cons_No)) THEN
			SET Par_NumErr := 3;
			SET Par_ErrMen := 'Valor para PEP No Valido.';
			SET Var_Control := 'clienteID';
			LEAVE ManejoErrores;
		END IF;

		# SE CONSULTA EL PARÁMETRO SI SE ENCUENTRA ENCENDIDO (SI).
		SET Var_AltaConocimiento := LEFT(TRIM(FNPARAMGENERALES('AltaConocimientoCTEPLD')),1);
		SET Var_AltaConocimiento := IF(TRIM(Var_AltaConocimiento) = Cadena_Vacia,Cons_No,Var_AltaConocimiento);
		SET Var_ClienteID := (SELECT ClienteID FROM CONOCIMIENTOCTE WHERE ClienteID = Par_ClienteID);

		# SI EL CONOCIMIENTO EXISTE.
		IF(IFNULL(Var_ClienteID,Entero_Cero) != Entero_Cero)THEN
			# SE ACTUALIZA EL CONOCIMIENTO DEL CLIENTE.
			UPDATE CONOCIMIENTOCTE
			SET
				PEPs			= Cons_Si,

				EmpresaID		= Aud_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual		= Aud_FechaActual,
				DireccionIP		= Aud_DireccionIP,
				ProgramaID		= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE ClienteID = Par_ClienteID;

			# REGISTRO EN HISTÓRICO DE CAMBIOS.
			CALL BITACORAHISTPERSALT(
				Aud_NumTransaccion,		Alta_ConocimientoCTE,		Par_ClienteID,		Entero_Cero,		Entero_Cero,
				Entero_Cero,			Cons_No,					Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,
				Aud_Usuario,			Aud_FechaActual,			Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
				Aud_NumTransaccion);

			IF(Par_NumErr!=Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		ELSE
			IF(Var_AltaConocimiento = Cons_Si)THEN
				# SE REGISTRA EL CONOCIMIENTO DEL CLIENTE CON VALORES DEFAULT EXCEPTO ESPEP.
				CALL CONOCIMIENTOCTEALT(
					Par_ClienteID,			Par_NomGrupo,			Par_RFC,				Par_Participacion,		Par_Nacionalidad,
					Par_RazonSocial,		Par_Giro,				Par_PEPs,				Par_FuncionID,			Par_ParentescoPEP,
					Par_NombFam,			Par_aPaternoFam,		Par_aMaternoFam,		Par_NoEmpleados,		Par_Serv_Produc,
					Par_CoberGeograf,		Par_Edos_Presen,		Par_ImporteVta,			Par_Activos,			Par_Pasivos,
					Par_Capital,			Par_Importa,			Par_DolImport,			Par_PaisImport,			Par_PaisImport2,
					Par_PaisImport3,		Par_Exporta,			Par_DolExport,			Par_PaisExport,			Par_PaisExport2,
					Par_PaisExport3,		Par_NombRefCom,			Par_NombRefCom2,		Par_TelRefCom,			Par_TelRefCom2,
					Par_BancoRef,			Par_BancoRef2,			Par_NoCtaRef,			Par_NoCtaRef2,			Par_NombreRef,
					Par_NombreRef2,			Par_DomRef,				Par_DomRef2,			Par_TelRef,				Par_TelRef2,
					Par_pFteIng,			Par_IngAproxMes,		Par_ExtTelRef1,			Par_ExtTelRef2,			Par_ExtTelRefCom,
					Par_ExtTelRefCom2,		Par_Relacion1,			Par_Relacion2,			Par_PregUno,			Par_RespUno,
					Par_PregDos,			Par_RespDos,			Par_PregTres,			Par_RespTres,			Par_PregCuatro,
					Par_RespCuatro,			Par_CapitalContable,	Par_NivelRiesgo,		Par_EvaluaXMatriz,		Par_ComentarioNivel,
					Par_NoCuentaRefCom,		Par_NoCuentaRefCom2,	Par_DireccionRefCom,	Par_DireccionRefCom2,	Par_BanTipoCuentaRef,
					Par_BanTipoCuentaRef2,	Par_BanSucursalRef,		Par_BanSucursalRef2,	Par_BanNoTarjetaRef,	Par_BanNoTarjetaRef2,
					Par_BanTarjetaInsRef,	Par_BanTarjetaInsRef2,	Par_BanCredOtraEnt,		Par_BanCredOtraEnt2,	Par_BanInsOtraEnt,
					Par_BanInsOtraEnt2,		Par_FechaNombramiento,	Par_PeriodoCargo,		Par_PorcentajeAcciones,	Par_MontoAcciones,
					Par_TiposClientes,		Par_InstMonetarios,		Par_OperacionAnios,		Par_GiroAnios,			Cons_No,
					Par_NumErr,				Par_ErrMen,				Aud_EmpresaID,			Aud_Usuario,			Aud_FechaActual,
					Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

				IF(Par_NumErr!=Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF;

		SET Par_NumErr := 0;
		SET Par_ErrMen := CONCAT('Conocimiento del ',FNGENERALOCALE('safilocale.cliente'),' Actualizado Exitosamente: ',Par_ClienteID,'.');
		SET Var_Control := 'clienteID';
		LEAVE ManejoErrores;
	END IF;

END ManejoErrores;

	IF(Par_Salida = Cons_Si)THEN
	  SELECT
		Par_NumErr AS NumErr,
		Par_ErrMen AS ErrMen,
		Var_Control AS Control,
		Par_ClienteID AS Consecutivo;
	END IF;

END TerminaStore$$

