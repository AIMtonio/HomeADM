-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORAHISTPERSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BITACORAHISTPERSALT`;
DELIMITER $$

CREATE PROCEDURE `BITACORAHISTPERSALT`(
	-- SP para dar de alta el historico de modificaciones de CLIENTES
	Par_NumTransaccionMod						BIGINT(20),						-- Numero de Transacción que realiza la modificación
	Par_TipoAlta								TINYINT,						-- Tipo de Alta
	Par_ClavePersonaInv							INT(11),						-- Clave de la Persona
	Par_CuentaAhoID 							BIGINT(12),						-- Numero de Cuenta
	Par_DireccionID								INT(11),						-- Numero de Direccion
	Par_IdentificID								INT(11),						-- Numero de Identificacion

	Par_Salida									CHAR(1),						-- Salida S:Si N:No
	INOUT Par_NumErr							INT(11),						-- Numero de error
	INOUT Par_ErrMen							VARCHAR(400),					-- Mensaje de Error

	-- Parametros de Auditoria
	Aud_EmpresaID								INT(11),
	Aud_Usuario									INT(11),
	Aud_FechaActual								DATETIME,
	Aud_DireccionIP								VARCHAR(15),
	Aud_ProgramaID								VARCHAR(50),
	Aud_Sucursal								INT(11),
	Aud_NumTransaccion							BIGINT(20)
)
TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE Var_Control							VARCHAR(50);					-- Variable con el ID del control de Pantalla
	DECLARE Var_Consecutivo						VARCHAR(50);					-- Variable campo de pantalla

	-- Declaracion de constantes
	DECLARE Salida_SI							CHAR(1);						-- Salida Si
	DECLARE Salida_NO							CHAR(1);						-- Salida No
	DECLARE Entero_Cero							INT(11);						-- Entero Cero
	DECLARE Alt_Clientes						INT(11);						-- Alta de Clientes
	DECLARE Alt_Direcciones						INT(11);						-- Alta de Direcciones
	DECLARE Alta_ConocimientoCTE				INT(11);						-- Alta Conocimiento del Cliente
	DECLARE Alta_Identificaciones				INT(11);						-- Alta de Identificaciones del Cliente
	DECLARE Alta_UsuariosServ					INT(11);						-- Alta de Usuarios de Servicios
	DECLARE Alta_ConocimientoCTA				INT(11);						-- Alta de Conocimiento de la Cta
	DECLARE Alta_ConocimientoUsrServ			INT(11);						-- Alta de concocimiento de usuario de servicios.
	DECLARE Cadena_Vacia						CHAR(1);
	DECLARE Fecha_Vacia							DATE;
	DECLARE Varori_ActividadBancoMX				VARCHAR(15); 					-- Actividad Principal del Cte, segun Banco de Mexico,Llave Foranea Hacia tabla ACTIVIDADESBMX
	DECLARE Varori_ActividadFOMURID				INT(11); 						-- Actividad Fomur del Cte, segun la ACTIVIDADESFOMUR
	DECLARE Varori_ActividadFR					BIGINT(20); 					-- Actividad Principal del Cte, segun la ACTIVIDADESFR
	DECLARE Varori_ActividadINEGI				INT(11); 						-- Actividad Principal del Cte, segun INEGI,Llave Foranea Hacia tabla ACTIVIDADESINEGI
	DECLARE Varori_Activos 						DECIMAL(14,2);
	DECLARE Varori_AMaternoFam 					VARCHAR(50);
	DECLARE Varori_APaternoFam 					VARCHAR(50);
	DECLARE Varori_ApellidoMaterno				VARCHAR(50); 					-- Apellido Materno del Cliente
	DECLARE Varori_ApellidoPaterno 				VARCHAR(50); 					-- Apellido Paterno del Usuario de Servicios
	DECLARE Varori_Calle 						VARCHAR(50); 					-- Nombre de la calle del domicilio
	DECLARE Varori_Capital 						DECIMAL(14,2);
	DECLARE Varori_Cober_Geograf 				CHAR(10); 						-- valor : L=Local\nE=Estatal\nR=Regional\nN=Nacional\nI=Internacional\n',
	DECLARE Varori_ColoniaID 					INT(11); 						-- Numero de Colonia del Usuario de Servicios, llave foranea de COLONIASREPUB
	DECLARE Varori_CP 							CHAR(5); 						-- Codigo Postal del domicilio
	DECLARE Varori_CURP 						CHAR(18); 						-- Clave Unica de Registro Poblacional
	DECLARE Varori_Descripcion 					VARCHAR(45);
	DECLARE Varori_DocEstanciaLegal 			VARCHAR(3); 					-- Documento de Estancial Legal
	DECLARE Varori_DocExisLegal 				VARCHAR(30); 					-- Documento de Existencia Legal
	DECLARE Varori_DolaresExport 				CHAR(5); 						-- valores:\nmenos1000:DExp\n1,001 a 5,000: DExp2\n5,001 a 10,000: DExp3\nmayor10001:DExp4\n\n',
	DECLARE Varori_DolaresImport 				CHAR(5); 						-- valores:\nmenos1000:DImp\n1,001 a 5,000:DImp2\n5,001 a 10,000:DImp3\nMayores 10,001DImp4',
	DECLARE Varori_EscrituraPubPM				VARCHAR(20); 					-- Escritura Publica Persona Moral
	DECLARE Varori_EstadoCivil					CHAR(2); 						-- Clave Estado Civil:\\n\\''S\\'' = Soltero\\n\\''CS\\''  = Casado Bienes Separados\\n\\''CM\\''  = Casado Bienes Mancomunados\\n\\''CC\\''  = Casado Bienes Mancomunados Con Capitulacion\\n\\''V\\'' = Viudo\\n\\''D\\'' = Divorciado\\n\\''SE\\''  = Separado\\n\\''U\\'' = Union Libre
	DECLARE Varori_EstadoID 					INT(11); 						-- Hace referencia al ID del Estado del Usuario de Servicios
	DECLARE Varori_EstadoNacimiento 			INT(11); 						-- Pais de Nacimiento, llave foranea a ESTADOSREPUB
	DECLARE Varori_Exporta 						CHAR(1); 						-- Valores Si=S\nNo=N',
	DECLARE Varori_FEA 							VARCHAR(250); 					-- Firma Electrónica Avanzada, en caso de contar con ella.
	DECLARE Varori_FecExIden 					DATE; 							-- Fecha de Expedición de la Identificación
	DECLARE Varori_FechaConstitucion 			DATE; 							-- Fecha de Constitucion ante el Registro Federal de Contribuyentes.
	DECLARE Varori_FechaNacimiento 				DATE; 							-- Fecha de Nacimiento del Usuario de Servicios
	DECLARE Varori_FechaVenEst 					DATE; 							-- Fecha de Vencimiento de la Estancia
	DECLARE Varori_FecVenIden 					DATE; 							-- Fecha de Vencimiento de la Identificación
	DECLARE Varori_Fiscal 						CHAR(1);						-- Es domicilio Fiscal S:Si N:No
	DECLARE Varori_FuncionID 					INT(11);
	DECLARE Varori_Giro 						VARCHAR(100); 					-- En caso de tener actividad empresarial',
	DECLARE Varori_GrupoEmpresarial				INT(11); 						-- Llave Foranea Hacia tabla GRUPOSEMP si existe peor no es necesaria.
	DECLARE Varori_Importa 						CHAR(1); 						-- Valores Si=S\nNo=N',
	DECLARE Varori_IngAproxMes 					VARCHAR(10);
	DECLARE Varori_InscripcionReg				VARCHAR(50); 					-- Inscripcion en el registro publico campo para Persona Moral
	DECLARE Varori_LocalidadID 					INT(11); 						-- Numero de Localidad del Usuario de Servicios, llave foranea de LOCALIDADREPUB
	DECLARE Varori_LugardeTrabajo				VARCHAR(100); 					-- Lugar donde Trabaja
	DECLARE Varori_LugarNacimiento				INT(11); 						-- Pais de Nacimiento, llave foranea a PAISES
	DECLARE Varori_MunicipioID 					INT(11); 						-- Hace referencia al ID del muncipio del Usuario de Servicios
	DECLARE Varori_Nacion						CHAR(1); 						-- Nacionalidad del cliente''N'' = Nacional''E'' = Extranjero
	DECLARE Varori_Nacionalidad 				CHAR(1); 						-- Nacionalidad del Usuario de Servicios\n''N'' = Nacional\n''E'' = Extranjero
	DECLARE Varori_Nacionalidad45 				VARCHAR(45); 					-- En caso de pertenecer a una sociedad, grupo o filial',
	DECLARE Varori_NivelRiesgo					CHAR(1); 						-- \nNivel de riesgo del cliente:\nA .-  Alto\nM .- Medio\nB .-  Bajo
	DECLARE Varori_NombFamiliar 				VARCHAR(50);
	DECLARE Varori_NombreNotario				VARCHAR(150); 					-- Nombre Notario campo para Persona Moral
	DECLARE Varori_NomGrupo 					VARCHAR(100); 					-- En caso de pertenecer a una sociedad, grupo o filial\n',
	DECLARE Varori_NumExterior 					VARCHAR(10); 					-- Numero Exterior del domicilio
	DECLARE Varori_NumIdenti 					VARCHAR(30); 					-- Numero de identificacion del documento de identifiación del Usuario de Servicios
	DECLARE Varori_NumIdentific 				VARCHAR(30); 					-- Es el num de identificacion del documento del cliente',
	DECLARE Varori_NumInterior 					VARCHAR(10); 					-- Numero Interior del domicilio
	DECLARE Varori_NumNotario					INT(11); 						-- Numero de Notario campo para Persona Moral
	DECLARE Varori_OcupacionID					INT(5); 						-- Profesión del cliente,Llave Foranea Hacia tabla OCUPACIONES si existe pero no es necesario.
	DECLARE Varori_Oficial 						CHAR(1);						-- Valor de direccion oficial\nS=SI, N=No
	DECLARE Varori_PaisConstitucionID			INT(11); 						-- Pais de Constitucion de la empresa
	DECLARE Varori_PaisesExport 				VARCHAR(50);
	DECLARE Varori_PaisesExport2 				VARCHAR(50);
	DECLARE Varori_PaisesExport3 				VARCHAR(50);
	DECLARE Varori_PaisesImport 				VARCHAR(50);
	DECLARE Varori_PaisesImport2 				VARCHAR(50);
	DECLARE Varori_PaisesImport3 				VARCHAR(50);
	DECLARE Varori_PaisNacimiento 				INT(11); 						-- Pais de Nacimiento, llave foranea a PAISES
	DECLARE Varori_PaisResidencia 				INT(11); 						-- Pais de Residencia, Llave Foranea Hacia tabla PAISES
	DECLARE Varori_PaisRFC 						INT(11); 						-- Pais que Asigna el Registro Federal de Contribuyentes.
	DECLARE Varori_ParentescoPEP 				CHAR(1); 						-- Valor: S =Si\nN= No',
	DECLARE Varori_Participacion 				DECIMAL(14,2); 					-- En caso de pertenecer a una sociedad, grupo o filial',
	DECLARE Varori_Pasivos 						DECIMAL(14,2);
	DECLARE Varori_PEPs 						CHAR(1); 						-- Persona politicamente expuesta, aque individuo que desempeña o ha desempeñado funciones publicas destacadas en un pais extrajero o territorio nacional\nValor: S =Si\nN= No\n',
	DECLARE Varori_PFuenteIng 					VARCHAR(100); 					-- Principal Fuente de Ingresos\n',
	DECLARE Varori_PrimerNombre					VARCHAR(50); 					-- Primer Nombre del Cliente
	DECLARE Varori_Puesto						VARCHAR(100); 					-- Puesto en el Trabajo
	DECLARE Varori_RazonSocial					VARCHAR(150); 					-- Razon Social
	DECLARE Varori_RFC 							CHAR(13); 						-- Registro Federal de Contribuyentes del Usuario de Servicios
	DECLARE Varori_RFCOficial					CHAR(13); 						-- RFC del cliente ya sea RFC que es asignado como persona fisica o el RFC como persona moral
	DECLARE Varori_RFCpm 						CHAR(13); 						-- Registro Federal de Contribuyentes del Usuario de Servicios, cuando esta sea Persona Moral
	DECLARE Varori_SectorEconomico				INT(11); 						-- Sector Economico Segun INEGI,Llave Foranea Hacia tabla SECTORESECONOM
	DECLARE Varori_SectorGeneral				INT(3); 						-- Sector General del Cliente,Llave Foranea Hacia tabla SECTORES
	DECLARE Varori_SegundoNombre				VARCHAR(50); 					-- Segundo Nombre del Cliente
	DECLARE Varori_Sexo							CHAR(1); 						-- Codigo de sexo del cliente\nClave Sexo:''M'' = Masculino''F''  = Femenino
	DECLARE Varori_SucursalOrigen 				INT(11); 						-- No de Sucursal en la que se da de Alta el Usuario, Llave Foranea Hacia Tabla SUCURSALES
	DECLARE Varori_TercerNombre 				VARCHAR(50); 					-- Tercer Nombre del Usuario de Servicios
	DECLARE Varori_TipoDireccionID 				INT(11); 						-- ID de el tipo de Dirección del Usuario de Servicios,Llave Foranea de TIPOSDIRECCION.
	DECLARE Varori_TipoIdentiID 				INT(11); 						-- ID de el tipo de identificacion del cliente',
	DECLARE Varori_TipoPersona					CHAR(1); 						-- Tipo de Personalidad del Cliente M.- Persona Moral A.- Persona Fisica Con Actividad Empresarial F.- Persona Fisica Sin Actividad Empresarial
	DECLARE Varori_TipoSociedadID				INT(11); 						-- Tipo de Sociedad, tiene llave foranea a la tabla  TIPOSOCIEDAD si existe pero no es necesaria
	DECLARE Varori_DepositoCred					DECIMAL(12,2);
	DECLARE Varori_RetirosCargo					DECIMAL(12,2);
	DECLARE Varori_ProcRecursos 				VARCHAR(80); 					-- Procedencia de los recursos para la Apertura
	DECLARE Varori_ConcentFondo 				CHAR(1); 						-- Su cuenta la utilizara para concentracion de Fondos? Si=S No=N
	DECLARE Varori_AdmonGtosIng 				CHAR(1); 						-- Su cuenta la utilizara para Administracion de Gastos e Ingresos? Si=S No=N
	DECLARE Varori_PagoNomina 					CHAR(1); 						-- Su cuenta la utilizara para Pago de Nomina? Si=S No=N
	DECLARE Varori_CtaInversion 				CHAR(1); 						-- Su cuenta la utilizara para cuenta para inversion? Si=S No=N
	DECLARE Varori_PagoCreditos 				CHAR(1); 						-- Su cuenta la utilizara para cuenta para Pagos de Credios? Si=S No=N
	DECLARE Varori_MediosElectronicos 			CHAR(1);						-- Su cuenta la utilizara para cuenta para Medios Electronicos? Si=S No=N',
	DECLARE Varori_OtroUso 						CHAR(1); 						-- Su cuenta la utilizara para cuenta para otro uso? Si=S No=N
	DECLARE Varori_DefineUso 					VARCHAR(40); 					-- Definir otro uso en caso de que OtroUso = S
	DECLARE Varori_RecursoProvProp 				CHAR(2); 						-- Los \r\nrecursos que manejara en su cuenta provienen de Recursos Propios = P
	DECLARE Varori_RecursoProvTer 				CHAR(2); 						-- Los recursos que manejara en su cuenta provienen de Recursos de Terceros = T
	DECLARE Varori_NumDepositos 				INT(11); 						-- Numero de Depositos permitidos para la Cuenta.
	DECLARE Varori_FrecDepositos 				INT(11); 						-- Frecuencia (en días) de Depositos permitidos para la Cuenta.
	DECLARE Varori_NumDepoApli 					INT(11); 						-- Numero de Depositos Aplicados, Incrementa con Cada Deposito a la Cuenta.\nInicia en Cero
	DECLARE Varori_NumRetiros 					INT(11); 						-- Numero de Retiros permitidos para la Cuenta.
	DECLARE Varori_FrecRetiros 					INT(11); 						-- Frecuencia (en días) de Retiros permitidos para la Cuenta.
	DECLARE Varori_NumRetiApli 					INT(11); 						-- Numero de Retiros Aplicados, Incrementa con Cada Retiro a la Cuenta.\nInicia en Cero
	DECLARE Varori_OperacionAnios				INT(11);
	DECLARE	Varori_GiroAnios					INT(11);



	DECLARE Varpld_ActividadBancoMX				VARCHAR(15); 					-- Actividad Principal del Cte, segun Banco de Mexico,Llave Foranea Hacia tabla ACTIVIDADESBMX
	DECLARE Varpld_ActividadFOMURID				INT(11); 						-- Actividad Fomur del Cte, segun la ACTIVIDADESFOMUR
	DECLARE Varpld_ActividadFR					BIGINT(20); 					-- Actividad Principal del Cte, segun la ACTIVIDADESFR
	DECLARE Varpld_ActividadINEGI				INT(11); 						-- Actividad Principal del Cte, segun INEGI,Llave Foranea Hacia tabla ACTIVIDADESINEGI
	DECLARE Varpld_Activos 						DECIMAL(14,2);
	DECLARE Varpld_AMaternoFam 					VARCHAR(50);
	DECLARE Varpld_APaternoFam 					VARCHAR(50);
	DECLARE Varpld_ApellidoMaterno				VARCHAR(50); 					-- Apellido Materno del Cliente
	DECLARE Varpld_ApellidoPaterno				VARCHAR(50); 					-- Apellido Paterno del Cliente
	DECLARE Varpld_Calle 						VARCHAR(50); 					-- Nombre de la calle del domicilio
	DECLARE Varpld_Capital 						DECIMAL(14,2);
	DECLARE Varpld_Cober_Geograf 				CHAR(10); 						-- valor : L=Local\nE=Estatal\nR=Regional\nN=Nacional\nI=Internacional\n',
	DECLARE Varpld_ColoniaID 					INT(11); 						-- Numero de Colonia del Usuario de Servicios, llave foranea de COLONIASREPUB
	DECLARE Varpld_CP 							CHAR(5);						-- Codigo Postal
	DECLARE Varpld_CURP							CHAR(18); 						-- Clave Unica de Registro Poblacional
	DECLARE Varpld_Descripcion 					VARCHAR(45);
	DECLARE Varpld_DocEstanciaLegal 			VARCHAR(3); 					-- Documento de Estancial Legal
	DECLARE Varpld_DocExisLegal 				VARCHAR(30); 					-- Documento de Existencia Legal
	DECLARE Varpld_DolaresExport 				CHAR(5); 						-- valores:\nmenos1000:DExp\n1,001 a 5,000: DExp2\n5,001 a 10,000: DExp3\nmayor10001:DExp4\n\n',
	DECLARE Varpld_DolaresImport 				CHAR(5); 						-- valores:\nmenos1000:DImp\n1,001 a 5,000:DImp2\n5,001 a 10,000:DImp3\nMayores 10,001DImp4',
	DECLARE Varpld_EscrituraPubPM				VARCHAR(20); 					-- Escritura Publica Persona Moral
	DECLARE Varpld_EstadoCivil					CHAR(2); 						-- Clave Estado Civil:\\n\\''S\\'' = Soltero\\n\\''CS\\''  = Casado Bienes Separados\\n\\''CM\\''  = Casado Bienes Mancomunados\\n\\''CC\\''  = Casado Bienes Mancomunados Con Capitulacion\\n\\''V\\'' = Viudo\\n\\''D\\'' = Divorciado\\n\\''SE\\''  = Separado\\n\\''U\\'' = Union Libre
	DECLARE Varpld_EstadoID						INT(11); 						-- Identificador de Estado que Se Encuentra en la tabla ESTADOSREPUB
	DECLARE Varpld_EstadoNacimiento 			INT(11); 						-- Pais de Nacimiento, llave foranea a ESTADOSREPUB
	DECLARE Varpld_Exporta 						CHAR(1); 						-- Valores Si=S\nNo=N',
	DECLARE Varpld_FEA 							VARCHAR(250); 					-- Firma Electrónica Avanzada, en caso de contar con ella.
	DECLARE Varpld_FecExIden 					DATE; 							-- Fecha de Expedición de la Identificación
	DECLARE Varpld_FechaConstitucion			DATE; 							-- Fecha de Constitucion ante el Registro Federal de Contribuyentes.
	DECLARE Varpld_FechaNacimiento				DATE; 							-- Fecha Nacimiento del Cliente o Rep Legal
	DECLARE Varpld_FechaVenEst 					DATE; 							-- Fecha de Vencimiento de la Estancia
	DECLARE Varpld_FecVenIden 					DATE; 							-- Fecha de Vencimiento de la Identificación
	DECLARE Varpld_Fiscal 						CHAR(1);						-- Es domicilio Fiscal S:Si N:No
	DECLARE Varpld_FuncionID 					INT(11);
	DECLARE Varpld_Giro 						VARCHAR(100); 					-- En caso de tener actividad empresarial',
	DECLARE Varpld_GrupoEmpresarial				INT(11); 						-- Llave Foranea Hacia tabla GRUPOSEMP si existe peor no es necesaria.
	DECLARE Varpld_Importa 						CHAR(1); 						-- Valores Si=S\nNo=N',
	DECLARE Varpld_IngAproxMes 					VARCHAR(10);
	DECLARE Varpld_InscripcionReg				VARCHAR(50); 					-- Inscripcion en el registro publico campo para Persona Moral
	DECLARE Varpld_LocalidadID 					INT(11);						-- Numero de Localidad Correspondiente al Municipio
	DECLARE Varpld_LugardeTrabajo				VARCHAR(100); 					-- Lugar donde Trabaja
	DECLARE Varpld_LugarNacimiento				INT(11); 						-- Pais de Nacimiento, llave foranea a PAISES
	DECLARE Varpld_MunicipioID 					INT(11);						-- Hace referencia al ID del muncipio del cliente
	DECLARE Varpld_Nacion						CHAR(1); 						-- Nacionalidad del cliente''N'' = Nacional''E'' = Extranjero
	DECLARE Varpld_Nacionalidad 				CHAR(1); 						-- Nacionalidad del Usuario de Servicios\n''N'' = Nacional\n''E'' = Extranjero
	DECLARE Varpld_Nacionalidad45 				VARCHAR(45); 					-- En caso de pertenecer a una sociedad, grupo o filial',
	DECLARE Varpld_NivelRiesgo					CHAR(1); 						-- \nNivel de riesgo del cliente:\nA .-  Alto\nM .- Medio\nB .-  Bajo
	DECLARE Varpld_NombFamiliar 				VARCHAR(50);
	DECLARE Varpld_NombreNotario				VARCHAR(150); 					-- Nombre Notario campo para Persona Moral
	DECLARE Varpld_NomGrupo 					VARCHAR(100); 					-- En caso de pertenecer a una sociedad, grupo o filial\n',
	DECLARE Varpld_NumExterior 					VARCHAR(10); 					-- Numero Exterior del domicilio
	DECLARE Varpld_NumIdenti 					VARCHAR(30); 					-- Numero de identificacion del documento de identifiación del Usuario de Servicios
	DECLARE Varpld_NumIdentific 				VARCHAR(30); 					-- Es el num de identificacion del documento del cliente',
	DECLARE Varpld_NumInterior 					VARCHAR(10); 					-- Numero Interior del domicilio
	DECLARE Varpld_NumNotario					INT(11); 						-- Numero de Notario campo para Persona Moral
	DECLARE Varpld_OcupacionID 					INT(5); 						-- Profesión del cliente,Llave Foranea Hacia tabla OCUPACIONES
	DECLARE Varpld_Oficial 						CHAR(1);						-- Valor de direccion oficial\nS=SI, N=No
	DECLARE Varpld_PaisConstitucionID			INT(11); 						-- Pais de Constitucion de la empresa
	DECLARE Varpld_PaisesExport 				VARCHAR(50);
	DECLARE Varpld_PaisesExport2 				VARCHAR(50);
	DECLARE Varpld_PaisesExport3 				VARCHAR(50);
	DECLARE Varpld_PaisesImport 				VARCHAR(50);
	DECLARE Varpld_PaisesImport2 				VARCHAR(50);
	DECLARE Varpld_PaisesImport3 				VARCHAR(50);
	DECLARE Varpld_PaisNacimiento 				INT(11); 						-- Pais de Nacimiento, llave foranea a PAISES
	DECLARE Varpld_PaisResidencia 				INT(11); 						-- Pais de Residencia, Llave Foranea Hacia tabla PAISES
	DECLARE Varpld_PaisRFC 						INT(11); 						-- Pais que Asigna el Registro Federal de Contribuyentes.
	DECLARE Varpld_ParentescoPEP 				CHAR(1); 						-- Valor: S =Si\nN= No',
	DECLARE Varpld_Participacion 				DECIMAL(14,2); 					-- En caso de pertenecer a una sociedad, grupo o filial',
	DECLARE Varpld_Pasivos 						DECIMAL(14,2);
	DECLARE Varpld_PEPs 						CHAR(1); 						-- Persona politicamente expuesta, aque individuo que desempeña o ha desempeñado funciones publicas destacadas en un pais extrajero o territorio nacional\nValor: S =Si\nN= No\n',
	DECLARE Varpld_PFuenteIng 					VARCHAR(100); 					-- Principal Fuente de Ingresos\n',
	DECLARE Varpld_PrimerNombre					VARCHAR(50); 					-- Primer Nombre del Cliente
	DECLARE Varpld_Puesto						VARCHAR(100); 					-- Puesto en el Trabajo
	DECLARE Varpld_RazonSocial 					VARCHAR(150); 					-- Razon Social, tratandose de Personas Morales
	DECLARE Varpld_RFC 							VARCHAR(13); 					-- En caso de pertenecer a una sociedad, grupo o filial',
	DECLARE Varpld_RFCOficial					CHAR(13); 						-- RFC del cliente ya sea RFC que es asignado como persona fisica o el RFC como persona moral
	DECLARE Varpld_RFCpm						CHAR(13); 						-- RFC de persona moral
	DECLARE Varpld_SectorEconomico				INT(11); 						-- Sector Economico Segun INEGI,Llave Foranea Hacia tabla SECTORESECONOM
	DECLARE Varpld_SectorGeneral				INT(3); 						-- Sector General del Cliente,Llave Foranea Hacia tabla SECTORES
	DECLARE Varpld_SegundoNombre				VARCHAR(50); 					-- Segundo Nombre del Cliente
	DECLARE Varpld_Sexo							CHAR(1); 						-- Codigo de sexo del cliente\nClave Sexo:''M'' = Masculino''F''  = Femenino
	DECLARE Varpld_SucursalOrigen 				INT(11); 						-- No de Sucursal en la que se da de Alta el Usuario, Llave Foranea Hacia Tabla SUCURSALES
	DECLARE Varpld_TercerNombre					VARCHAR(50); 					-- Tercer Nombre Del Cliente
	DECLARE Varpld_TipoDireccionID 				INT(11); 						-- ID de el tipo de Dirección del Usuario de Servicios,Llave Foranea de TIPOSDIRECCION.
	DECLARE Varpld_TipoIdentiID 				INT(11); 						-- ID de el tipo de identificacion del cliente',
	DECLARE Varpld_TipoPersona					CHAR(1); 						-- Tipo de Personalidad del Cliente M.- Persona Moral A.- Persona Fisica Con Actividad Empresarial F.- Persona Fisica Sin Actividad Empresarial
	DECLARE Varpld_TipoSociedadID				INT(11); 						-- Tipo de Sociedad, tiene llave foranea a la tabla  TIPOSOCIEDAD si existe pero no es necesaria
	DECLARE Varpld_DepositoCred					DECIMAL(12,2);
	DECLARE Varpld_RetirosCargo					DECIMAL(12,2);
	DECLARE Varpld_ProcRecursos 				VARCHAR(80); 					-- Procedencia de los recursos para la Apertura
	DECLARE Varpld_ConcentFondo 				CHAR(1); 						-- Su cuenta la utilizara para concentracion de Fondos? Si=S No=N
	DECLARE Varpld_AdmonGtosIng 				CHAR(1); 						-- Su cuenta la utilizara para Administracion de Gastos e Ingresos? Si=S No=N
	DECLARE Varpld_PagoNomina 					CHAR(1); 						-- Su cuenta la utilizara para Pago de Nomina? Si=S No=N
	DECLARE Varpld_CtaInversion 				CHAR(1); 						-- Su cuenta la utilizara para cuenta para inversion? Si=S No=N
	DECLARE Varpld_PagoCreditos 				CHAR(1); 						-- Su cuenta la utilizara para cuenta para Pagos de Credios? Si=S No=N
	DECLARE Varpld_MediosElectronicos 			CHAR(1);						-- Su cuenta la utilizara para cuenta para Medios Electronicos? Si=S No=N',
	DECLARE Varpld_OtroUso 						CHAR(1); 						-- Su cuenta la utilizara para cuenta para otro uso? Si=S No=N
	DECLARE Varpld_DefineUso 					VARCHAR(40); 					-- Definir otro uso en caso de que OtroUso = S
	DECLARE Varpld_RecursoProvProp 				CHAR(2); 						-- Los \r\nrecursos que manejara en su cuenta provienen de Recursos Propios = P
	DECLARE Varpld_RecursoProvTer 				CHAR(2); 						-- Los recursos que manejara en su cuenta provienen de Recursos de Terceros = T
	DECLARE Varpld_NumDepositos 				INT(11); 						-- Numero de Depositos permitidos para la Cuenta.
	DECLARE Varpld_FrecDepositos 				INT(11); 						-- Frecuencia (en días) de Depositos permitidos para la Cuenta.
	DECLARE Varpld_NumRetiros 					INT(11); 						-- Numero de Retiros permitidos para la Cuenta.
	DECLARE Varpld_FrecRetiros 					INT(11); 						-- Frecuencia (en días) de Retiros permitidos para la Cuenta.
	DECLARE Varpld_OperacionAnios				INT(11);
	DECLARE Varpld_GiroAnios					INT(11);

	-- Asignacion de constantes
	SET Salida_SI					:= 'S';
	SET Salida_NO					:= 'N';
	SET Cadena_Vacia				:= '';
	SET Fecha_Vacia					:= '1900-01-01';
	SET Entero_Cero					:= 0;
	SET Alt_Clientes				:= 1;					-- Alta de Clientes
	SET Alt_Direcciones				:= 2;					-- Alta de Direcciones
	SET Alta_ConocimientoCTE		:= 3;					-- Alta Conocimiento del Cliente
	SET Alta_Identificaciones		:= 4;					-- Alta de Identificaciones del Cliente
	SET Alta_UsuariosServ			:= 5;					-- Alta de Usuarios de Servicios
	SET Alta_ConocimientoCTA 		:= 6;					-- Alta de Conocimiento de la Cuenta
	SET Alta_ConocimientoUsrServ	:= 7;					-- Alta conocimiento de usuario de servicios.

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-BITACORAHISTPERSALT');
			SET Var_Control := 'sqlException';
		END;

		-- Alta 		: 001
		-- Descripcion	: Alta de Historico de Modificaciones de Clientes
		IF(Par_TipoAlta = Alt_Clientes) THEN

			SELECT
			CTE.TipoPersona,				CTE.PrimerNombre,					CTE.SegundoNombre,			CTE.TercerNombre,					CTE.ApellidoPaterno,
			CTE.ApellidoMaterno,			CTE.FechaNacimiento,				CTE.CURP,					CTE.Nacion,							CTE.PaisResidencia,
			CTE.GrupoEmpresarial,			CTE.RazonSocial,					CTE.TipoSociedadID,			CTE.RFC,							CTE.RFCpm,
			CTE.RFCOficial,					CTE.SectorGeneral,					CTE.ActividadBancoMX,		CTE.ActividadINEGI,					CTE.ActividadFR,
			CTE.ActividadFOMURID,			CTE.SectorEconomico,				CTE.Sexo,					CTE.EstadoCivil,					CTE.LugarNacimiento,
			CTE.EstadoID,					CTE.OcupacionID,					CTE.LugardeTrabajo,			CTE.Puesto,							CTE.NivelRiesgo,
			CTE.FechaConstitucion,			CTE.PaisConstitucionID,				CTE.NombreNotario,			CTE.NumNotario,						CTE.InscripcionReg,
			CTE.EscrituraPubPM,				CTE.FEA
			INTO
			Varpld_TipoPersona,				Varpld_PrimerNombre,				Varpld_SegundoNombre,		Varpld_TercerNombre,			Varpld_ApellidoPaterno,
			Varpld_ApellidoMaterno,			Varpld_FechaNacimiento,				Varpld_CURP,				Varpld_Nacion,					Varpld_PaisResidencia,
			Varpld_GrupoEmpresarial,		Varpld_RazonSocial,					Varpld_TipoSociedadID,		Varpld_RFC,						Varpld_RFCpm,
			Varpld_RFCOficial,				Varpld_SectorGeneral,				Varpld_ActividadBancoMX,	Varpld_ActividadINEGI,			Varpld_ActividadFR,
			Varpld_ActividadFOMURID,		Varpld_SectorEconomico,				Varpld_Sexo,				Varpld_EstadoCivil,				Varpld_LugarNacimiento,
			Varpld_EstadoID,				Varpld_OcupacionID,					Varpld_LugardeTrabajo,		Varpld_Puesto,					Varpld_NivelRiesgo,
			Varpld_FechaConstitucion,		Varpld_PaisConstitucionID,			Varpld_NombreNotario,		Varpld_NumNotario,				Varpld_InscripcionReg,
			Varpld_EscrituraPubPM,			Varpld_FEA
			FROM HISCLIENTES AS CTE
				WHERE ClienteID = Par_ClavePersonaInv
				ORDER BY FechaActual DESC
				LIMIT 1;

			SELECT
			CTE.TipoPersona,				CTE.PrimerNombre,					CTE.SegundoNombre,			CTE.TercerNombre,					CTE.ApellidoPaterno,
			CTE.ApellidoMaterno,			CTE.FechaNacimiento,				CTE.CURP,					CTE.Nacion,							CTE.PaisResidencia,
			CTE.GrupoEmpresarial,			CTE.RazonSocial,					CTE.TipoSociedadID,			CTE.RFC,							CTE.RFCpm,
			CTE.RFCOficial,					CTE.SectorGeneral,					CTE.ActividadBancoMX,		CTE.ActividadINEGI,					CTE.ActividadFR,
			CTE.ActividadFOMURID,			CTE.SectorEconomico,				CTE.Sexo,					CTE.EstadoCivil,					CTE.LugarNacimiento,
			CTE.EstadoID,					CTE.OcupacionID,					CTE.LugardeTrabajo,			CTE.Puesto,							CTE.NivelRiesgo,
			CTE.FechaConstitucion,			CTE.PaisConstitucionID,				CTE.NombreNotario,			CTE.NumNotario,						CTE.InscripcionReg,
			CTE.EscrituraPubPM,				CTE.FEA
			INTO
			Varori_TipoPersona,				Varori_PrimerNombre,				Varori_SegundoNombre,		Varori_TercerNombre,				Varori_ApellidoPaterno,
			Varori_ApellidoMaterno,			Varori_FechaNacimiento,				Varori_CURP,				Varori_Nacion,						Varori_PaisResidencia,
			Varori_GrupoEmpresarial,		Varori_RazonSocial,					Varori_TipoSociedadID,		Varori_RFC,							Varori_RFCpm,
			Varori_RFCOficial,				Varori_SectorGeneral,				Varori_ActividadBancoMX,	Varori_ActividadINEGI,				Varori_ActividadFR,
			Varori_ActividadFOMURID,		Varori_SectorEconomico,				Varori_Sexo,				Varori_EstadoCivil,					Varori_LugarNacimiento,
			Varori_EstadoID,				Varori_OcupacionID,					Varori_LugardeTrabajo,		Varori_Puesto,						Varori_NivelRiesgo,
			Varori_FechaConstitucion,		Varori_PaisConstitucionID,			Varori_NombreNotario,		Varori_NumNotario,					Varori_InscripcionReg,
			Varori_EscrituraPubPM,			Varori_FEA
			FROM CLIENTES AS CTE
				WHERE ClienteID = Par_ClavePersonaInv;

			SET Varpld_TipoPersona 					:= IFNULL(Varpld_TipoPersona, Cadena_Vacia);
			SET Varpld_PrimerNombre 				:= IFNULL(Varpld_PrimerNombre, Cadena_Vacia);
			SET Varpld_SegundoNombre 				:= IFNULL(Varpld_SegundoNombre, Cadena_Vacia);
			SET Varpld_TercerNombre 				:= IFNULL(Varpld_TercerNombre, Cadena_Vacia);
			SET Varpld_ApellidoPaterno 				:= IFNULL(Varpld_ApellidoPaterno, Cadena_Vacia);
			SET Varpld_ApellidoMaterno 				:= IFNULL(Varpld_ApellidoMaterno, Cadena_Vacia);
			SET Varpld_FechaNacimiento 				:= IFNULL(Varpld_FechaNacimiento, Fecha_Vacia);
			SET Varpld_CURP 						:= IFNULL(Varpld_CURP, Cadena_Vacia);
			SET Varpld_Nacion 						:= IFNULL(Varpld_Nacion, Cadena_Vacia);
			SET Varpld_PaisResidencia 				:= IFNULL(Varpld_PaisResidencia, Entero_Cero);
			SET Varpld_GrupoEmpresarial 			:= IFNULL(Varpld_GrupoEmpresarial, Entero_Cero);
			SET Varpld_RazonSocial 					:= IFNULL(Varpld_RazonSocial, Cadena_Vacia);
			SET Varpld_TipoSociedadID 				:= IFNULL(Varpld_TipoSociedadID, Entero_Cero);
			SET Varpld_RFC 							:= IFNULL(Varpld_RFC, Cadena_Vacia);
			SET Varpld_RFCpm 						:= IFNULL(Varpld_RFCpm, Cadena_Vacia);
			SET Varpld_RFCOficial 					:= IFNULL(Varpld_RFCOficial, Cadena_Vacia);
			SET Varpld_SectorGeneral 				:= IFNULL(Varpld_SectorGeneral, Entero_Cero);
			SET Varpld_ActividadBancoMX 			:= IFNULL(Varpld_ActividadBancoMX, Cadena_Vacia);
			SET Varpld_ActividadINEGI 				:= IFNULL(Varpld_ActividadINEGI, Entero_Cero);
			SET Varpld_ActividadFR 					:= IFNULL(Varpld_ActividadFR, Entero_Cero);
			SET Varpld_ActividadFOMURID 			:= IFNULL(Varpld_ActividadFOMURID, Entero_Cero);
			SET Varpld_SectorEconomico 				:= IFNULL(Varpld_SectorEconomico, Entero_Cero);
			SET Varpld_Sexo 						:= IFNULL(Varpld_Sexo, Cadena_Vacia);
			SET Varpld_EstadoCivil 					:= IFNULL(Varpld_EstadoCivil, Cadena_Vacia);
			SET Varpld_LugarNacimiento 				:= IFNULL(Varpld_LugarNacimiento, Entero_Cero);
			SET Varpld_EstadoID 					:= IFNULL(Varpld_EstadoID, Entero_Cero);
			SET Varpld_OcupacionID 					:= IFNULL(Varpld_OcupacionID, Entero_Cero);
			SET Varpld_LugardeTrabajo 				:= IFNULL(Varpld_LugardeTrabajo, Cadena_Vacia);
			SET Varpld_Puesto 						:= IFNULL(Varpld_Puesto, Cadena_Vacia);
			SET Varpld_NivelRiesgo 					:= IFNULL(Varpld_NivelRiesgo, Cadena_Vacia);
			SET Varpld_FechaConstitucion 			:= IFNULL(Varpld_FechaConstitucion, Fecha_Vacia);
			SET Varpld_PaisConstitucionID 			:= IFNULL(Varpld_PaisConstitucionID, Entero_Cero);
			SET Varpld_NombreNotario 				:= IFNULL(Varpld_NombreNotario, Cadena_Vacia);
			SET Varpld_NumNotario 					:= IFNULL(Varpld_NumNotario, Entero_Cero);
			SET Varpld_InscripcionReg 				:= IFNULL(Varpld_InscripcionReg, Cadena_Vacia);
			SET Varpld_EscrituraPubPM 				:= IFNULL(Varpld_EscrituraPubPM, Cadena_Vacia);
			SET Varpld_FEA 							:= IFNULL(Varpld_FEA, Cadena_Vacia);

			SET Varori_TipoPersona 					:= IFNULL(Varori_TipoPersona, Cadena_Vacia);
			SET Varori_PrimerNombre 				:= IFNULL(Varori_PrimerNombre, Cadena_Vacia);
			SET Varori_SegundoNombre 				:= IFNULL(Varori_SegundoNombre, Cadena_Vacia);
			SET Varori_TercerNombre 				:= IFNULL(Varori_TercerNombre, Cadena_Vacia);
			SET Varori_ApellidoPaterno 				:= IFNULL(Varori_ApellidoPaterno, Cadena_Vacia);
			SET Varori_ApellidoMaterno 				:= IFNULL(Varori_ApellidoMaterno, Cadena_Vacia);
			SET Varori_FechaNacimiento 				:= IFNULL(Varori_FechaNacimiento, Fecha_Vacia);
			SET Varori_CURP 						:= IFNULL(Varori_CURP, Cadena_Vacia);
			SET Varori_Nacion 						:= IFNULL(Varori_Nacion, Cadena_Vacia);
			SET Varori_PaisResidencia 				:= IFNULL(Varori_PaisResidencia, Entero_Cero);
			SET Varori_GrupoEmpresarial 			:= IFNULL(Varori_GrupoEmpresarial, Entero_Cero);
			SET Varori_RazonSocial 					:= IFNULL(Varori_RazonSocial, Cadena_Vacia);
			SET Varori_TipoSociedadID 				:= IFNULL(Varori_TipoSociedadID, Entero_Cero);
			SET Varori_RFC 							:= IFNULL(Varori_RFC, Cadena_Vacia);
			SET Varori_RFCpm 						:= IFNULL(Varori_RFCpm, Cadena_Vacia);
			SET Varori_RFCOficial 					:= IFNULL(Varori_RFCOficial, Cadena_Vacia);
			SET Varori_SectorGeneral 				:= IFNULL(Varori_SectorGeneral, Entero_Cero);
			SET Varori_ActividadBancoMX 			:= IFNULL(Varori_ActividadBancoMX, Cadena_Vacia);
			SET Varori_ActividadINEGI 				:= IFNULL(Varori_ActividadINEGI, Entero_Cero);
			SET Varori_ActividadFR 					:= IFNULL(Varori_ActividadFR, Entero_Cero);
			SET Varori_ActividadFOMURID 			:= IFNULL(Varori_ActividadFOMURID, Entero_Cero);
			SET Varori_SectorEconomico 				:= IFNULL(Varori_SectorEconomico, Entero_Cero);
			SET Varori_Sexo 						:= IFNULL(Varori_Sexo, Cadena_Vacia);
			SET Varori_EstadoCivil 					:= IFNULL(Varori_EstadoCivil, Cadena_Vacia);
			SET Varori_LugarNacimiento 				:= IFNULL(Varori_LugarNacimiento, Entero_Cero);
			SET Varori_EstadoID 					:= IFNULL(Varori_EstadoID, Entero_Cero);
			SET Varori_OcupacionID 					:= IFNULL(Varori_OcupacionID, Entero_Cero);
			SET Varori_LugardeTrabajo 				:= IFNULL(Varori_LugardeTrabajo, Cadena_Vacia);
			SET Varori_Puesto 						:= IFNULL(Varori_Puesto, Cadena_Vacia);
			SET Varori_NivelRiesgo 					:= IFNULL(Varori_NivelRiesgo, Cadena_Vacia);
			SET Varori_FechaConstitucion 			:= IFNULL(Varori_FechaConstitucion, Fecha_Vacia);
			SET Varori_PaisConstitucionID 			:= IFNULL(Varori_PaisConstitucionID, Entero_Cero);
			SET Varori_NombreNotario 				:= IFNULL(Varori_NombreNotario, Cadena_Vacia);
			SET Varori_NumNotario 					:= IFNULL(Varori_NumNotario, Entero_Cero);
			SET Varori_InscripcionReg 				:= IFNULL(Varori_InscripcionReg, Cadena_Vacia);
			SET Varori_EscrituraPubPM 				:= IFNULL(Varori_EscrituraPubPM, Cadena_Vacia);
			SET Varori_FEA 							:= IFNULL(Varori_FEA, Cadena_Vacia);

			IF(			Varpld_TipoPersona 			!= Varori_TipoPersona 			OR 		Varpld_PrimerNombre 		!= Varori_PrimerNombre
				OR 		Varpld_SegundoNombre 		!= Varori_SegundoNombre 		OR 		Varpld_TercerNombre 		!= Varori_TercerNombre
				OR 		Varpld_ApellidoPaterno 		!= Varori_ApellidoPaterno 		OR 		Varpld_ApellidoMaterno 		!= Varori_ApellidoMaterno
				OR 		Varpld_FechaNacimiento 		!= Varori_FechaNacimiento 		OR 		Varpld_CURP 				!= Varori_CURP
				OR 		Varpld_Nacion 				!= Varori_Nacion 				OR 		Varpld_PaisResidencia 		!= Varori_PaisResidencia
				OR 		Varpld_GrupoEmpresarial 	!= Varori_GrupoEmpresarial 		OR 		Varpld_RazonSocial 			!= Varori_RazonSocial
				OR 		Varpld_TipoSociedadID 		!= Varori_TipoSociedadID 		OR 		Varpld_RFC 					!= Varori_RFC
				OR 		Varpld_RFCpm 				!= Varori_RFCpm 				OR 		Varpld_RFCOficial 			!= Varori_RFCOficial
				OR 		Varpld_SectorGeneral 		!= Varori_SectorGeneral 		OR 		Varpld_ActividadBancoMX 	!= Varori_ActividadBancoMX
				OR 		Varpld_ActividadINEGI 		!= Varori_ActividadINEGI 		OR 		Varpld_ActividadFR 			!= Varori_ActividadFR
				OR 		Varpld_ActividadFOMURID 	!= Varori_ActividadFOMURID 		OR 		Varpld_SectorEconomico 		!= Varori_SectorEconomico
				OR 		Varpld_Sexo 				!= Varori_Sexo 					OR 		Varpld_EstadoCivil 			!= Varori_EstadoCivil
				OR 		Varpld_LugarNacimiento 		!= Varori_LugarNacimiento 		OR 		Varpld_EstadoID 			!= Varori_EstadoID
				OR 		Varpld_OcupacionID 			!= Varori_OcupacionID 			OR 		Varpld_LugardeTrabajo 		!= Varori_LugardeTrabajo
				OR 		Varpld_Puesto 				!= Varori_Puesto 				OR 		Varpld_NivelRiesgo 			!= Varori_NivelRiesgo
				OR 		Varpld_FechaConstitucion 	!= Varori_FechaConstitucion 	OR 		Varpld_PaisConstitucionID 	!= Varori_PaisConstitucionID
				OR 		Varpld_NombreNotario 		!= Varori_NombreNotario 		OR 		Varpld_NumNotario 			!= Varori_NumNotario
				OR 		Varpld_InscripcionReg 		!= Varori_InscripcionReg 		OR 		Varpld_EscrituraPubPM 		!= Varori_EscrituraPubPM
				OR		Varpld_FEA 					!= Varori_FEA) THEN


				INSERT INTO HISCLIENTES(
					NumTransaccionAct,				ClienteID,						TipoPersona,					Titulo,						PrimerNombre,
					SegundoNombre,					TercerNombre,					ApellidoPaterno,				ApellidoMaterno,			FechaNacimiento,
					CURP,							Nacion,							PaisResidencia,					GrupoEmpresarial,			RazonSocial,
					TipoSociedadID,					RFC,							RFCpm,							RFCOficial,					SectorGeneral,
					ActividadBancoMX,				ActividadINEGI,					ActividadFR,					ActividadFOMURID,			SectorEconomico,
					Sexo,							EstadoCivil,					LugarNacimiento,				EstadoID,					OcupacionID,
					LugardeTrabajo,					Puesto,							NivelRiesgo,					NombreCompleto,				FechaConstitucion,
					PaisConstitucionID,				NombreNotario,					NumNotario,						InscripcionReg,				EscrituraPubPM,
					FEA,							Usuario,						FechaActual,					DireccionIP,				ProgramaID,
					Sucursal,						NumTransaccion)
				SELECT
					Par_NumTransaccionMod,			CTE.ClienteID,					CTE.TipoPersona,				CTE.Titulo,					CTE.PrimerNombre,
					CTE.SegundoNombre,				CTE.TercerNombre,				CTE.ApellidoPaterno,			CTE.ApellidoMaterno,		CTE.FechaNacimiento,
					CTE.CURP,						CTE.Nacion,						CTE.PaisResidencia,				CTE.GrupoEmpresarial,		CTE.RazonSocial,
					CTE.TipoSociedadID,				CTE.RFC,						CTE.RFCpm,						CTE.RFCOficial,				CTE.SectorGeneral,
					CTE.ActividadBancoMX,			CTE.ActividadINEGI,				CTE.ActividadFR,				CTE.ActividadFOMURID,		CTE.SectorEconomico,
					CTE.Sexo,						CTE.EstadoCivil,				CTE.LugarNacimiento,			CTE.EstadoID,				CTE.OcupacionID,
					CTE.LugardeTrabajo,				CTE.Puesto,						CTE.NivelRiesgo,				CTE.NombreCompleto,			CTE.FechaConstitucion,
					CTE.PaisConstitucionID,			CTE.NombreNotario,				CTE.NumNotario,					CTE.InscripcionReg,			CTE.EscrituraPubPM,
					CTE.FEA,						CTE.Usuario,					CTE.FechaActual,				CTE.DireccionIP,			CTE.ProgramaID,
					CTE.Sucursal,					CTE.NumTransaccion
					FROM CLIENTES AS CTE
						WHERE ClienteID = Par_ClavePersonaInv;
			END IF;
		END IF;

		-- Alta 		: 002
		-- Descripcion	: Alta de Historico de Modificaciones de Direcciones de Cliente
		IF(Par_TipoAlta = Alt_Direcciones) THEN
			SELECT
				HIS.EstadoID,		HIS.MunicipioID,		HIS.LocalidadID,		HIS.CP,		HIS.Oficial,
				HIS.Fiscal
				INTO
				Varpld_EstadoID,	Varpld_MunicipioID,		Varpld_LocalidadID,		Varpld_CP,	Varpld_Oficial,
				Varpld_Fiscal
				FROM HISDIRECCLIENTE AS HIS
				WHERE
				HIS.ClienteID = Par_ClavePersonaInv AND HIS.DireccionID = Par_DireccionID
				ORDER BY FechaActual DESC
				LIMIT 1;

			SELECT
				DIR.EstadoID,		DIR.MunicipioID,		DIR.LocalidadID,		DIR.CP,		DIR.Oficial,
				DIR.Fiscal
				INTO
				Varori_EstadoID,	Varori_MunicipioID,		Varori_LocalidadID,		Varori_CP,	Varori_Oficial,
				Varori_Fiscal
				FROM DIRECCLIENTE AS DIR
				WHERE
				DIR.ClienteID = Par_ClavePersonaInv AND DIR.DireccionID = Par_DireccionID;


			SET Varpld_EstadoID 			:= IFNULL(Varpld_EstadoID, Entero_Cero);
			SET Varpld_MunicipioID 			:= IFNULL(Varpld_MunicipioID, Entero_Cero);
			SET Varpld_LocalidadID 			:= IFNULL(Varpld_LocalidadID, Entero_Cero);
			SET Varpld_CP 					:= IFNULL(Varpld_CP, Cadena_Vacia);
			SET Varpld_Oficial 				:= IFNULL(Varpld_Oficial, Cadena_Vacia);
			SET Varpld_Fiscal 				:= IFNULL(Varpld_Fiscal, Cadena_Vacia);

			SET Varori_EstadoID 			:= IFNULL(Varori_EstadoID, Entero_Cero);
			SET Varori_MunicipioID 			:= IFNULL(Varori_MunicipioID, Entero_Cero);
			SET Varori_LocalidadID 			:= IFNULL(Varori_LocalidadID, Entero_Cero);
			SET Varori_CP 					:= IFNULL(Varori_CP, Cadena_Vacia);
			SET Varori_Oficial 				:= IFNULL(Varori_Oficial, Cadena_Vacia);
			SET Varori_Fiscal 				:= IFNULL(Varori_Fiscal, Cadena_Vacia);

			IF(			Varpld_EstadoID 			!= Varori_EstadoID 			OR 		Varpld_MunicipioID 		!= Varori_MunicipioID
				OR 		Varpld_LocalidadID 			!= Varori_LocalidadID		OR 		Varpld_CP 				!= Varori_CP
				OR 		Varpld_Oficial 				!= Varori_Oficial 			OR 		Varpld_Fiscal 			!= Varori_Fiscal) THEN
				INSERT INTO HISDIRECCLIENTE(
					NumTransaccionAct,				ClienteID,						DireccionID,					PaisID,						EstadoID,
					MunicipioID,					LocalidadID,					CP,								AniosRes,					Oficial,
					Fiscal,							Usuario,						FechaActual,					DireccionIP,				ProgramaID,
					Sucursal,						NumTransaccion)
				SELECT
					Par_NumTransaccionMod,			DIR.ClienteID,					DIR.DireccionID,				DIR.PaisID,					DIR.EstadoID,
					DIR.MunicipioID,				DIR.LocalidadID,				DIR.CP,							DIR.AniosRes,				DIR.Oficial,
					DIR.Fiscal,						DIR.Usuario,					DIR.FechaActual,				DIR.DireccionIP,			DIR.ProgramaID,
					DIR.Sucursal,					DIR.NumTransaccion
					FROM
						DIRECCLIENTE AS DIR
						WHERE
							DIR.ClienteID			= Par_ClavePersonaInv AND
							DIR.DireccionID			= Par_DireccionID;
			END IF;
		END IF;

		-- Alta 		: 003
		-- Descripcion	: Alta de Historico de Modificaciones de Conocimiento del Cliente
		IF(Par_TipoAlta = Alta_ConocimientoCTE) THEN
			SELECT
				HIS.NomGrupo,			HIS.RFC,				HIS.Participacion,			HIS.Nacionalidad,			HIS.RazonSocial,
				HIS.Giro,				HIS.PEPs,				HIS.FuncionID,				HIS.ParentescoPEP,			HIS.NombFamiliar,
				HIS.APaternoFam,		HIS.AMaternoFam,		HIS.Cober_Geograf,			HIS.Activos,				HIS.Pasivos,
				HIS.Capital,			HIS.Importa,			HIS.DolaresImport,			HIS.PaisesImport,			HIS.PaisesImport2,
				HIS.PaisesImport3,		HIS.Exporta,			HIS.DolaresExport,			HIS.PaisesExport,			HIS.PaisesExport2,
				HIS.PaisesExport3,		HIS.PFuenteIng,			HIS.OperacionAnios,			HIS.GiroAnios,				HIS.IngAproxMes
				INTO
				Varpld_NomGrupo,		Varpld_RFC,				Varpld_Participacion,		Varpld_Nacionalidad45,		Varpld_RazonSocial,
				Varpld_Giro,			Varpld_PEPs,			Varpld_FuncionID,			Varpld_ParentescoPEP,		Varpld_NombFamiliar,
				Varpld_APaternoFam,		Varpld_AMaternoFam,		Varpld_Cober_Geograf,		Varpld_Activos,				Varpld_Pasivos,
				Varpld_Capital,			Varpld_Importa,			Varpld_DolaresImport,		Varpld_PaisesImport,		Varpld_PaisesImport2,
				Varpld_PaisesImport3,	Varpld_Exporta,			Varpld_DolaresExport,		Varpld_PaisesExport,		Varpld_PaisesExport2,
				Varpld_PaisesExport3,	Varpld_PFuenteIng,		Varpld_OperacionAnios,		Varpld_GiroAnios,			Varpld_IngAproxMes
				FROM HISCONOCIMIENTOCTE AS HIS
					WHERE
						HIS.ClienteID = Par_ClavePersonaInv
						ORDER BY HIS.FechaActual DESC
							LIMIT 1;

			SELECT
				CTE.NomGrupo,			CTE.RFC,				CTE.Participacion,			CTE.Nacionalidad,			CTE.RazonSocial,
				CTE.Giro,				CTE.PEPs,				CTE.FuncionID,				CTE.ParentescoPEP,			CTE.NombFamiliar,
				CTE.APaternoFam,		CTE.AMaternoFam,		CTE.Cober_Geograf,			CTE.Activos,				CTE.Pasivos,
				CTE.Capital,			CTE.Importa,			CTE.DolaresImport,			CTE.PaisesImport,			CTE.PaisesImport2,
				CTE.PaisesImport3,		CTE.Exporta,			CTE.DolaresExport,			CTE.PaisesExport,			CTE.PaisesExport2,
				CTE.PaisesExport3,		CTE.PFuenteIng,			CTE.OperacionAnios,			CTE.GiroAnios,              CTE.IngAproxMes
				INTO
				Varori_NomGrupo,		Varori_RFC,				Varori_Participacion,		Varori_Nacionalidad45,		Varori_RazonSocial,
				Varori_Giro,			Varori_PEPs,			Varori_FuncionID,			Varori_ParentescoPEP,		Varori_NombFamiliar,
				Varori_APaternoFam,		Varori_AMaternoFam,		Varori_Cober_Geograf,		Varori_Activos,				Varori_Pasivos,
				Varori_Capital,			Varori_Importa,			Varori_DolaresImport,		Varori_PaisesImport,		Varori_PaisesImport2,
				Varori_PaisesImport3,	Varori_Exporta,			Varori_DolaresExport,		Varori_PaisesExport,		Varori_PaisesExport2,
				Varori_PaisesExport3,	Varori_PFuenteIng,		Varori_OperacionAnios,		Varori_GiroAnios,			Varori_IngAproxMes
				FROM CONOCIMIENTOCTE AS CTE
					WHERE
						CTE.ClienteID = Par_ClavePersonaInv;

			SET Varpld_NomGrupo 			:= IFNULL(Varpld_NomGrupo, Cadena_Vacia);
			SET Varpld_RFC 					:= IFNULL(Varpld_RFC, Cadena_Vacia);
			SET Varpld_Participacion 		:= IFNULL(Varpld_Participacion, Entero_Cero);
			SET Varpld_Nacionalidad45 		:= IFNULL(Varpld_Nacionalidad45, Cadena_Vacia);
			SET Varpld_RazonSocial 			:= IFNULL(Varpld_RazonSocial, Cadena_Vacia);
			SET Varpld_Giro 				:= IFNULL(Varpld_Giro, Cadena_Vacia);
			SET Varpld_PEPs 				:= IFNULL(Varpld_PEPs, Cadena_Vacia);
			SET Varpld_FuncionID 			:= IFNULL(Varpld_FuncionID, Entero_Cero);
			SET Varpld_ParentescoPEP 		:= IFNULL(Varpld_ParentescoPEP, Cadena_Vacia);
			SET Varpld_NombFamiliar 		:= IFNULL(Varpld_NombFamiliar, Cadena_Vacia);
			SET Varpld_APaternoFam 			:= IFNULL(Varpld_APaternoFam, Cadena_Vacia);
			SET Varpld_AMaternoFam 			:= IFNULL(Varpld_AMaternoFam, Cadena_Vacia);
			SET Varpld_Cober_Geograf 		:= IFNULL(Varpld_Cober_Geograf, Cadena_Vacia);
			SET Varpld_Activos 				:= IFNULL(Varpld_Activos, Entero_Cero);
			SET Varpld_Pasivos 				:= IFNULL(Varpld_Pasivos, Entero_Cero);
			SET Varpld_Capital 				:= IFNULL(Varpld_Capital, Entero_Cero);
			SET Varpld_Importa 				:= IFNULL(Varpld_Importa, Cadena_Vacia);
			SET Varpld_DolaresImport 		:= IFNULL(Varpld_DolaresImport, Cadena_Vacia);
			SET Varpld_PaisesImport 		:= IFNULL(Varpld_PaisesImport, Cadena_Vacia);
			SET Varpld_PaisesImport2 		:= IFNULL(Varpld_PaisesImport2, Cadena_Vacia);
			SET Varpld_PaisesImport3 		:= IFNULL(Varpld_PaisesImport3, Cadena_Vacia);
			SET Varpld_Exporta 				:= IFNULL(Varpld_Exporta, Cadena_Vacia);
			SET Varpld_DolaresExport 		:= IFNULL(Varpld_DolaresExport, Cadena_Vacia);
			SET Varpld_PaisesExport 		:= IFNULL(Varpld_PaisesExport, Cadena_Vacia);
			SET Varpld_PaisesExport2 		:= IFNULL(Varpld_PaisesExport2, Cadena_Vacia);
			SET Varpld_PaisesExport3 		:= IFNULL(Varpld_PaisesExport3, Cadena_Vacia);
			SET Varpld_PFuenteIng 			:= IFNULL(Varpld_PFuenteIng, Cadena_Vacia);
			SET Varpld_IngAproxMes 			:= IFNULL(Varpld_IngAproxMes, Cadena_Vacia);
			SET Varpld_OperacionAnios		:= IFNULL(Varpld_OperacionAnios, Entero_Cero);
			SET Varpld_GiroAnios			:= IFNULL(Varpld_GiroAnios, Entero_Cero);

			SET Varori_NomGrupo 			:= IFNULL(Varori_NomGrupo, Cadena_Vacia);
			SET Varori_RFC 					:= IFNULL(Varori_RFC, Cadena_Vacia);
			SET Varori_Participacion 		:= IFNULL(Varori_Participacion, Entero_Cero);
			SET Varori_Nacionalidad45 		:= IFNULL(Varori_Nacionalidad45, Cadena_Vacia);
			SET Varori_RazonSocial 			:= IFNULL(Varori_RazonSocial, Cadena_Vacia);
			SET Varori_Giro 				:= IFNULL(Varori_Giro, Cadena_Vacia);
			SET Varori_PEPs 				:= IFNULL(Varori_PEPs, Cadena_Vacia);
			SET Varori_FuncionID 			:= IFNULL(Varori_FuncionID, Entero_Cero);
			SET Varori_ParentescoPEP 		:= IFNULL(Varori_ParentescoPEP, Cadena_Vacia);
			SET Varori_NombFamiliar 		:= IFNULL(Varori_NombFamiliar, Cadena_Vacia);
			SET Varori_APaternoFam 			:= IFNULL(Varori_APaternoFam, Cadena_Vacia);
			SET Varori_AMaternoFam 			:= IFNULL(Varori_AMaternoFam, Cadena_Vacia);
			SET Varori_Cober_Geograf 		:= IFNULL(Varori_Cober_Geograf, Cadena_Vacia);
			SET Varori_Activos 				:= IFNULL(Varori_Activos, Entero_Cero);
			SET Varori_Pasivos 				:= IFNULL(Varori_Pasivos, Entero_Cero);
			SET Varori_Capital 				:= IFNULL(Varori_Capital, Entero_Cero);
			SET Varori_Importa 				:= IFNULL(Varori_Importa, Cadena_Vacia);
			SET Varori_DolaresImport 		:= IFNULL(Varori_DolaresImport, Cadena_Vacia);
			SET Varori_PaisesImport 		:= IFNULL(Varori_PaisesImport, Cadena_Vacia);
			SET Varori_PaisesImport2 		:= IFNULL(Varori_PaisesImport2, Cadena_Vacia);
			SET Varori_PaisesImport3 		:= IFNULL(Varori_PaisesImport3, Cadena_Vacia);
			SET Varori_Exporta 				:= IFNULL(Varori_Exporta, Cadena_Vacia);
			SET Varori_DolaresExport 		:= IFNULL(Varori_DolaresExport, Cadena_Vacia);
			SET Varori_PaisesExport 		:= IFNULL(Varori_PaisesExport, Cadena_Vacia);
			SET Varori_PaisesExport2 		:= IFNULL(Varori_PaisesExport2, Cadena_Vacia);
			SET Varori_PaisesExport3 		:= IFNULL(Varori_PaisesExport3, Cadena_Vacia);
			SET Varori_PFuenteIng 			:= IFNULL(Varori_PFuenteIng, Cadena_Vacia);
			SET Varori_IngAproxMes 			:= IFNULL(Varori_IngAproxMes, Cadena_Vacia);
			SET Varori_OperacionAnios		:= IFNULL(Varori_OperacionAnios, Entero_Cero);
			SET Varori_GiroAnios			:= IFNULL(Varori_GiroAnios, Entero_Cero);

			IF(		Varpld_NomGrupo 		!= Varori_NomGrupo 				OR 		Varpld_RFC 				!= Varori_RFC
				OR 	Varpld_Participacion 	!= Varori_Participacion 		OR 		Varpld_Nacionalidad45 	!= Varori_Nacionalidad45
				OR Varpld_RazonSocial 		!= Varori_RazonSocial 			OR 		Varpld_Giro 			!= Varori_Giro
				OR Varpld_PEPs 				!= Varori_PEPs 					OR 		Varpld_FuncionID 		!= Varori_FuncionID
				OR Varpld_ParentescoPEP 	!= Varori_ParentescoPEP 		OR 		Varpld_NombFamiliar 	!= Varori_NombFamiliar
				OR Varpld_APaternoFam 		!= Varori_APaternoFam 			OR 		Varpld_AMaternoFam 		!= Varori_AMaternoFam
				OR Varpld_Cober_Geograf 	!= Varori_Cober_Geograf 		OR 		Varpld_Activos 			!= Varori_Activos
				OR Varpld_Pasivos 			!= Varori_Pasivos 				OR 		Varpld_Capital 			!= Varori_Capital
				OR Varpld_Importa 			!= Varori_Importa 				OR 		Varpld_DolaresImport 	!= Varori_DolaresImport
				OR Varpld_PaisesImport 		!= Varori_PaisesImport 			OR 		Varpld_PaisesImport2 	!= Varori_PaisesImport2
				OR Varpld_PaisesImport3 	!= Varori_PaisesImport3 		OR 		Varpld_Exporta 			!= Varori_Exporta
				OR Varpld_DolaresExport 	!= Varori_DolaresExport 		OR 		Varpld_PaisesExport 	!= Varori_PaisesExport
				OR Varpld_PaisesExport2 	!= Varori_PaisesExport2 		OR 		Varpld_PaisesExport3 	!= Varori_PaisesExport3
				OR Varpld_PFuenteIng 		!= Varori_PFuenteIng 			OR 		Varpld_IngAproxMes 		!= Varori_IngAproxMes
				OR Varpld_OperacionAnios	!= Varori_OperacionAnios		OR 		Varpld_GiroAnios		!= Varori_GiroAnios) THEN
				INSERT INTO HISCONOCIMIENTOCTE(
					NumTransaccionAct,				ClienteID,						NomGrupo,						RFC,						Participacion,
					Nacionalidad,					RazonSocial,					Giro,							PEPs,						FuncionID,
					ParentescoPEP,					NombFamiliar,					APaternoFam,					AMaternoFam,				Cober_Geograf,
					Activos,						Pasivos,						Capital,						Importa,					DolaresImport,
					PaisesImport,					PaisesImport2,					PaisesImport3,					Exporta,					DolaresExport,
					PaisesExport,					PaisesExport2,					PaisesExport3,					PFuenteIng,					OperacionAnios,
					GiroAnios,						IngAproxMes,					Usuario,						FechaActual,				DireccionIP,
					ProgramaID,						Sucursal,						NumTransaccion)
					SELECT
					Par_NumTransaccionMod,			CTE.ClienteID,					CTE.NomGrupo,					CTE.RFC,					CTE.Participacion,
					CTE.Nacionalidad,				CTE.RazonSocial,				CTE.Giro,						CTE.PEPs,					CTE.FuncionID,
					CTE.ParentescoPEP,				CTE.NombFamiliar,				CTE.APaternoFam,				CTE.AMaternoFam,			CTE.Cober_Geograf,
					CTE.Activos,					CTE.Pasivos,					CTE.Capital,					CTE.Importa,				CTE.DolaresImport,
					CTE.PaisesImport,				CTE.PaisesImport2,				CTE.PaisesImport3,				CTE.Exporta,				CTE.DolaresExport,
					CTE.PaisesExport,				CTE.PaisesExport2,				CTE.PaisesExport3,				CTE.PFuenteIng,				CTE.OperacionAnios,
					CTE.GiroAnios,					CTE.IngAproxMes,				CTE.Usuario,					CTE.FechaActual,			CTE.DireccionIP,
					CTE.ProgramaID,					CTE.Sucursal,
					NumTransaccion
					FROM CONOCIMIENTOCTE AS CTE
						WHERE ClienteID = Par_ClavePersonaInv;
			END IF;
		END IF;

		-- Alta 		: 004
		-- Descripcion	: Alta de Historico de Modificaciones de Identificaciones del Cliente
		IF(Par_TipoAlta = Alta_Identificaciones) THEN
			SELECT
				HIS.TipoIdentiID,				HIS.Descripcion,				HIS.Oficial,			HIS.NumIdentific,			HIS.FecExIden,
				HIS.FecVenIden
				INTO
				Varpld_TipoIdentiID,			Varpld_Descripcion,				Varpld_Oficial,			Varpld_NumIdentific,		Varpld_FecExIden,
				Varpld_FecVenIden
				FROM HISIDENTIFICLIENTE AS HIS
					WHERE HIS.ClienteID = Par_ClavePersonaInv AND
					HIS.IdentificID = Par_IdentificID
					ORDER BY FechaActual DESC
					LIMIT 1;
			SELECT
				IDE.TipoIdentiID,				IDE.Descripcion,				IDE.Oficial,			IDE.NumIdentific,			IDE.FecExIden,
				IDE.FecVenIden
				INTO
				Varori_TipoIdentiID,			Varori_Descripcion,				Varori_Oficial,		Varori_NumIdentific,			Varori_FecExIden,
				Varori_FecVenIden
				FROM IDENTIFICLIENTE AS IDE
					WHERE IDE.ClienteID = Par_ClavePersonaInv AND
					IDE.IdentificID = Par_IdentificID
					ORDER BY FechaActual DESC
					LIMIT 1;

			SET Varpld_TipoIdentiID 	:= IFNULL(Varpld_TipoIdentiID,Entero_Cero);
			SET Varpld_Descripcion 		:= IFNULL(Varpld_Descripcion,Cadena_Vacia);
			SET Varpld_Oficial 			:= IFNULL(Varpld_Oficial,Cadena_Vacia);
			SET Varpld_NumIdentific 	:= IFNULL(Varpld_NumIdentific,Cadena_Vacia);
			SET Varpld_FecExIden 		:= IFNULL(Varpld_FecExIden,Fecha_Vacia);
			SET Varpld_FecVenIden 		:= IFNULL(Varpld_FecVenIden,Fecha_Vacia);

			SET Varori_TipoIdentiID 	:= IFNULL(Varori_TipoIdentiID,Entero_Cero);
			SET Varori_Descripcion 		:= IFNULL(Varori_Descripcion,Cadena_Vacia);
			SET Varori_Oficial 			:= IFNULL(Varori_Oficial,Cadena_Vacia);
			SET Varori_NumIdentific 	:= IFNULL(Varori_NumIdentific,Cadena_Vacia);
			SET Varori_FecExIden 		:= IFNULL(Varori_FecExIden,Fecha_Vacia);
			SET Varori_FecVenIden 		:= IFNULL(Varori_FecVenIden,Fecha_Vacia);

			IF(Varpld_TipoIdentiID 			!= Varori_TipoIdentiID 		OR 		Varpld_Descripcion 			!= Varori_Descripcion OR
				Varpld_Oficial 				!= Varori_Oficial 			OR		Varpld_NumIdentific 		!= Varori_NumIdentific OR
				Varpld_FecExIden 			!= Varori_FecExIden 		OR		Varpld_FecVenIden 			!= Varori_FecVenIden) THEN
				INSERT INTO HISIDENTIFICLIENTE(
					NumTransaccionAct,			ClienteID,					IdentificID,				EmpresaID,				TipoIdentiID,
					Descripcion,				Oficial,					NumIdentific,				FecExIden,				FecVenIden,
					Usuario,					FechaActual,				DireccionIP,				ProgramaID,				Sucursal,
					NumTransaccion)
				SELECT
					Par_NumTransaccionMod,		IDE.ClienteID,				IDE.IdentificID,			IDE.EmpresaID,			IDE.TipoIdentiID,
					IDE.Descripcion,			IDE.Oficial,				IDE.NumIdentific,			IDE.FecExIden,			IDE.FecVenIden,
					IDE.Usuario,				IDE.FechaActual,			IDE.DireccionIP,			IDE.ProgramaID,			IDE.Sucursal,
					IDE.NumTransaccion
				FROM IDENTIFICLIENTE AS IDE
					WHERE ClienteID = Par_ClavePersonaInv AND
					IdentificID = Par_IdentificID;
			END IF;
		END IF;

		-- Alta 		: 005
		-- Descripcion	: Alta de Historico de Modificaciones de Usuario de Servicios*/
		IF(Par_TipoAlta = Alta_UsuariosServ) THEN

			SELECT
				HIS.TipoPersona,			HIS.PrimerNombre,			HIS.SegundoNombre,				HIS.TercerNombre,				HIS.ApellidoPaterno,
				HIS.ApellidoMaterno,		HIS.FechaNacimiento,		HIS.Nacionalidad,				HIS.PaisNacimiento,				HIS.EstadoNacimiento,
				HIS.Sexo,					HIS.CURP,					HIS.RazonSocial,				HIS.TipoSociedadID,				HIS.RFC,
				HIS.RFCpm,					HIS.FEA,					HIS.FechaConstitucion,			HIS.PaisRFC,					HIS.OcupacionID,
				HIS.PaisResidencia,			HIS.EstadoID,				HIS.MunicipioID,				HIS.LocalidadID,				HIS.ColoniaID,
				HIS.Calle,					HIS.NumExterior,			HIS.NumInterior,				HIS.CP,							HIS.NumIdenti,
				HIS.FecExIden,				HIS.FecVenIden,				HIS.DocEstanciaLegal,			HIS.DocExisLegal,				HIS.FechaVenEst
				INTO
				Varpld_TipoPersona,			Varpld_PrimerNombre,		Varpld_SegundoNombre,			Varpld_TercerNombre,			Varpld_ApellidoPaterno,
				Varpld_ApellidoMaterno,		Varpld_FechaNacimiento,		Varpld_Nacionalidad,			Varpld_PaisNacimiento,			Varpld_EstadoNacimiento,
				Varpld_Sexo,				Varpld_CURP,				Varpld_RazonSocial,				Varpld_TipoSociedadID,			Varpld_RFC,
				Varpld_RFCpm,				Varpld_FEA,					Varpld_FechaConstitucion,		Varpld_PaisRFC,					Varpld_OcupacionID,
				Varpld_PaisResidencia,		Varpld_EstadoID,			Varpld_MunicipioID,				Varpld_LocalidadID,				Varpld_ColoniaID,
				Varpld_Calle,				Varpld_NumExterior,			Varpld_NumInterior,				Varpld_CP,						Varpld_NumIdenti,
				Varpld_FecExIden,			Varpld_FecVenIden,			Varpld_DocEstanciaLegal,		Varpld_DocExisLegal,			Varpld_FechaVenEst
				FROM HISUSUARIOSERVICIO AS HIS
					WHERE
					HIS.UsuarioServicioID = Par_ClavePersonaInv
						ORDER BY HIS.FechaActual DESC
						LIMIT 1;

			SELECT
				USU.TipoPersona,			USU.PrimerNombre,			USU.SegundoNombre,				USU.TercerNombre,				USU.ApellidoPaterno,
				USU.ApellidoMaterno,		USU.FechaNacimiento,		USU.Nacionalidad,				USU.PaisNacimiento,				USU.EstadoNacimiento,
				USU.Sexo,					USU.CURP,					USU.RazonSocial,				USU.TipoSociedadID,				USU.RFC,
				USU.RFCpm,					USU.FEA,					USU.FechaConstitucion,			USU.PaisRFC,					USU.OcupacionID,
				USU.PaisResidencia,			USU.EstadoID,				USU.MunicipioID,				USU.LocalidadID,				USU.ColoniaID,
				USU.Calle,					USU.NumExterior,			USU.NumInterior,				USU.CP,							USU.NumIdenti,
				USU.FecExIden,				USU.FecVenIden,				USU.DocEstanciaLegal,			USU.DocExisLegal,				USU.FechaVenEst
				INTO
				Varori_TipoPersona,			Varori_PrimerNombre,		Varori_SegundoNombre,			Varori_TercerNombre,			Varori_ApellidoPaterno,
				Varori_ApellidoMaterno,		Varori_FechaNacimiento,		Varori_Nacionalidad,			Varori_PaisNacimiento,			Varori_EstadoNacimiento,
				Varori_Sexo,				Varori_CURP,				Varori_RazonSocial,				Varori_TipoSociedadID,			Varori_RFC,
				Varori_RFCpm,				Varori_FEA,					Varori_FechaConstitucion,		Varori_PaisRFC,					Varori_OcupacionID,
				Varori_PaisResidencia,		Varori_EstadoID,			Varori_MunicipioID,				Varori_LocalidadID,				Varori_ColoniaID,
				Varori_Calle,				Varori_NumExterior,			Varori_NumInterior,				Varori_CP,						Varori_NumIdenti,
				Varori_FecExIden,			Varori_FecVenIden,			Varori_DocEstanciaLegal,		Varori_DocExisLegal,			Varori_FechaVenEst
				FROM USUARIOSERVICIO AS USU
					WHERE
					USU.UsuarioServicioID = Par_ClavePersonaInv;


			SET Varpld_TipoPersona 				:= IFNULL(Varpld_TipoPersona, Cadena_Vacia);
			SET Varpld_PrimerNombre 			:= IFNULL(Varpld_PrimerNombre, Cadena_Vacia);
			SET Varpld_SegundoNombre 			:= IFNULL(Varpld_SegundoNombre, Cadena_Vacia);
			SET Varpld_TercerNombre 			:= IFNULL(Varpld_TercerNombre, Cadena_Vacia);
			SET Varpld_ApellidoPaterno 			:= IFNULL(Varpld_ApellidoPaterno, Cadena_Vacia);
			SET Varpld_ApellidoMaterno 			:= IFNULL(Varpld_ApellidoMaterno, Cadena_Vacia);
			SET Varpld_FechaNacimiento 			:= IFNULL(Varpld_FechaNacimiento, Fecha_Vacia);
			SET Varpld_Nacionalidad 			:= IFNULL(Varpld_Nacionalidad, Cadena_Vacia);
			SET Varpld_PaisNacimiento 			:= IFNULL(Varpld_PaisNacimiento, Entero_Cero);
			SET Varpld_EstadoNacimiento 		:= IFNULL(Varpld_EstadoNacimiento, Entero_Cero);
			SET Varpld_Sexo 					:= IFNULL(Varpld_Sexo, Cadena_Vacia);
			SET Varpld_CURP 					:= IFNULL(Varpld_CURP, Cadena_Vacia);
			SET Varpld_RazonSocial 				:= IFNULL(Varpld_RazonSocial, Cadena_Vacia);
			SET Varpld_TipoSociedadID 			:= IFNULL(Varpld_TipoSociedadID, Entero_Cero);
			SET Varpld_RFC 						:= IFNULL(Varpld_RFC, Cadena_Vacia);
			SET Varpld_RFCpm 					:= IFNULL(Varpld_RFCpm, Cadena_Vacia);
			SET Varpld_FEA 						:= IFNULL(Varpld_FEA, Cadena_Vacia);
			SET Varpld_FechaConstitucion 		:= IFNULL(Varpld_FechaConstitucion, Fecha_Vacia);
			SET Varpld_PaisRFC 					:= IFNULL(Varpld_PaisRFC, Entero_Cero);
			SET Varpld_OcupacionID 				:= IFNULL(Varpld_OcupacionID, Entero_Cero);
			SET Varpld_SucursalOrigen 			:= IFNULL(Varpld_SucursalOrigen, Entero_Cero);
			SET Varpld_PaisResidencia 			:= IFNULL(Varpld_PaisResidencia, Entero_Cero);
			SET Varpld_TipoDireccionID 			:= IFNULL(Varpld_TipoDireccionID, Entero_Cero);
			SET Varpld_EstadoID 				:= IFNULL(Varpld_EstadoID, Entero_Cero);
			SET Varpld_MunicipioID 				:= IFNULL(Varpld_MunicipioID, Entero_Cero);
			SET Varpld_LocalidadID 				:= IFNULL(Varpld_LocalidadID, Entero_Cero);
			SET Varpld_ColoniaID 				:= IFNULL(Varpld_ColoniaID, Entero_Cero);
			SET Varpld_Calle 					:= IFNULL(Varpld_Calle, Cadena_Vacia);
			SET Varpld_NumExterior 				:= IFNULL(Varpld_NumExterior, Cadena_Vacia);
			SET Varpld_NumInterior 				:= IFNULL(Varpld_NumInterior, Cadena_Vacia);
			SET Varpld_CP 						:= IFNULL(Varpld_CP, Cadena_Vacia);
			SET Varpld_NumIdenti 				:= IFNULL(Varpld_NumIdenti, Cadena_Vacia);
			SET Varpld_FecExIden 				:= IFNULL(Varpld_FecExIden, Fecha_Vacia);
			SET Varpld_FecVenIden 				:= IFNULL(Varpld_FecVenIden, Fecha_Vacia);
			SET Varpld_DocEstanciaLegal 		:= IFNULL(Varpld_DocEstanciaLegal, Cadena_Vacia);
			SET Varpld_DocExisLegal 			:= IFNULL(Varpld_DocExisLegal, Cadena_Vacia);
			SET Varpld_FechaVenEst 				:= IFNULL(Varpld_FechaVenEst, Fecha_Vacia);

			SET Varori_TipoPersona 				:= IFNULL(Varori_TipoPersona, Cadena_Vacia);
			SET Varori_PrimerNombre 			:= IFNULL(Varori_PrimerNombre, Cadena_Vacia);
			SET Varori_SegundoNombre 			:= IFNULL(Varori_SegundoNombre, Cadena_Vacia);
			SET Varori_TercerNombre 			:= IFNULL(Varori_TercerNombre, Cadena_Vacia);
			SET Varori_ApellidoPaterno 			:= IFNULL(Varori_ApellidoPaterno, Cadena_Vacia);
			SET Varori_ApellidoMaterno 			:= IFNULL(Varori_ApellidoMaterno, Cadena_Vacia);
			SET Varori_FechaNacimiento 			:= IFNULL(Varori_FechaNacimiento, Fecha_Vacia);
			SET Varori_Nacionalidad 			:= IFNULL(Varori_Nacionalidad, Cadena_Vacia);
			SET Varori_PaisNacimiento 			:= IFNULL(Varori_PaisNacimiento, Entero_Cero);
			SET Varori_EstadoNacimiento 		:= IFNULL(Varori_EstadoNacimiento, Entero_Cero);
			SET Varori_Sexo 					:= IFNULL(Varori_Sexo, Cadena_Vacia);
			SET Varori_CURP 					:= IFNULL(Varori_CURP, Cadena_Vacia);
			SET Varori_RazonSocial 				:= IFNULL(Varori_RazonSocial, Cadena_Vacia);
			SET Varori_TipoSociedadID 			:= IFNULL(Varori_TipoSociedadID, Entero_Cero);
			SET Varori_RFC 						:= IFNULL(Varori_RFC, Cadena_Vacia);
			SET Varori_RFCpm 					:= IFNULL(Varori_RFCpm, Cadena_Vacia);
			SET Varori_FEA 						:= IFNULL(Varori_FEA, Cadena_Vacia);
			SET Varori_FechaConstitucion 		:= IFNULL(Varori_FechaConstitucion, Fecha_Vacia);
			SET Varori_PaisRFC 					:= IFNULL(Varori_PaisRFC, Entero_Cero);
			SET Varori_OcupacionID 				:= IFNULL(Varori_OcupacionID, Entero_Cero);
			SET Varori_SucursalOrigen 			:= IFNULL(Varori_SucursalOrigen, Entero_Cero);
			SET Varori_PaisResidencia 			:= IFNULL(Varori_PaisResidencia, Entero_Cero);
			SET Varori_TipoDireccionID 			:= IFNULL(Varori_TipoDireccionID, Entero_Cero);
			SET Varori_EstadoID 				:= IFNULL(Varori_EstadoID, Entero_Cero);
			SET Varori_MunicipioID 				:= IFNULL(Varori_MunicipioID, Entero_Cero);
			SET Varori_LocalidadID 				:= IFNULL(Varori_LocalidadID, Entero_Cero);
			SET Varori_ColoniaID 				:= IFNULL(Varori_ColoniaID, Entero_Cero);
			SET Varori_Calle 					:= IFNULL(Varori_Calle, Cadena_Vacia);
			SET Varori_NumExterior 				:= IFNULL(Varori_NumExterior, Cadena_Vacia);
			SET Varori_NumInterior 				:= IFNULL(Varori_NumInterior, Cadena_Vacia);
			SET Varori_CP 						:= IFNULL(Varori_CP, Cadena_Vacia);
			SET Varori_NumIdenti 				:= IFNULL(Varori_NumIdenti, Cadena_Vacia);
			SET Varori_FecExIden 				:= IFNULL(Varori_FecExIden, Fecha_Vacia);
			SET Varori_FecVenIden 				:= IFNULL(Varori_FecVenIden, Fecha_Vacia);
			SET Varori_DocEstanciaLegal 		:= IFNULL(Varori_DocEstanciaLegal, Cadena_Vacia);
			SET Varori_DocExisLegal 			:= IFNULL(Varori_DocExisLegal, Cadena_Vacia);
			SET Varori_FechaVenEst 				:= IFNULL(Varori_FechaVenEst, Fecha_Vacia);

			IF(		Varpld_TipoPersona 			!= Varori_TipoPersona 			OR 				Varpld_PrimerNombre 		!= Varori_PrimerNombre
				OR 	Varpld_SegundoNombre 		!= Varori_SegundoNombre 		OR 				Varpld_TercerNombre 		!= Varori_TercerNombre
				OR 	Varpld_ApellidoPaterno 		!= Varori_ApellidoPaterno 		OR 				Varpld_ApellidoMaterno 		!= Varori_ApellidoMaterno
				OR 	Varpld_FechaNacimiento 		!= Varori_FechaNacimiento 		OR 				Varpld_Nacionalidad 		!= Varori_Nacionalidad
				OR 	Varpld_PaisNacimiento 		!= Varori_PaisNacimiento 		OR 				Varpld_EstadoNacimiento 	!= Varori_EstadoNacimiento
				OR 	Varpld_Sexo 				!= Varori_Sexo 					OR 				Varpld_CURP 				!= Varori_CURP
				OR 	Varpld_RazonSocial 			!= Varori_RazonSocial 			OR 				Varpld_TipoSociedadID 		!= Varori_TipoSociedadID
				OR 	Varpld_RFC 					!= Varori_RFC 					OR 				Varpld_RFCpm 				!= Varori_RFCpm
				OR 	Varpld_FEA 					!= Varori_FEA 					OR 				Varpld_FechaConstitucion 	!= Varori_FechaConstitucion
				OR 	Varpld_PaisRFC 				!= Varori_PaisRFC 				OR 				Varpld_OcupacionID 			!= Varori_OcupacionID
				OR 	Varpld_SucursalOrigen 		!= Varori_SucursalOrigen 		OR 				Varpld_PaisResidencia 		!= Varori_PaisResidencia
				OR 	Varpld_TipoDireccionID 		!= Varori_TipoDireccionID 		OR 				Varpld_EstadoID 			!= Varori_EstadoID
				OR 	Varpld_MunicipioID 			!= Varori_MunicipioID 			OR 				Varpld_LocalidadID 			!= Varori_LocalidadID
				OR 	Varpld_ColoniaID 			!= Varori_ColoniaID 			OR 				Varpld_Calle 				!= Varori_Calle
				OR 	Varpld_NumExterior 			!= Varori_NumExterior 			OR 				Varpld_NumInterior 			!= Varori_NumInterior
				OR 	Varpld_CP 					!= Varori_CP 					OR 				Varpld_NumIdenti 			!= Varori_NumIdenti
				OR 	Varpld_FecExIden 			!= Varori_FecExIden 			OR 				Varpld_FecVenIden 			!= Varori_FecVenIden
				OR 	Varpld_DocEstanciaLegal 	!= Varori_DocEstanciaLegal 		OR 				Varpld_DocExisLegal 		!= Varori_DocExisLegal
				OR 	Varpld_FechaVenEst 			!= Varori_FechaVenEst) THEN

				INSERT INTO HISUSUARIOSERVICIO(
					NumTransaccionAct,			UsuarioServicioID,			TipoPersona,				PrimerNombre,				SegundoNombre,
					TercerNombre,				ApellidoPaterno,			ApellidoMaterno,			FechaNacimiento,			Nacionalidad,
					PaisNacimiento,				EstadoNacimiento,			Sexo,						CURP,						RazonSocial,
					TipoSociedadID,				RFC,						RFCpm,						RFCOficial,					FEA,
					FechaConstitucion,			PaisRFC,					OcupacionID,				NombreCompleto,				SucursalOrigen,
					PaisResidencia,				TipoDireccionID,			EstadoID,					MunicipioID,				LocalidadID,
					ColoniaID,					Calle,						NumExterior,				NumInterior,				CP,
					NumIdenti,					FecExIden,					FecVenIden,					DocEstanciaLegal,			DocExisLegal,
					FechaVenEst,				EmpresaID,					Usuario,					FechaActual,				DireccionIP,
					ProgramaID,					Sucursal,					NumTransaccion)
					SELECT
					Par_NumTransaccionMod,		USU.UsuarioServicioID,		USU.TipoPersona,			USU.PrimerNombre,			USU.SegundoNombre,
					USU.TercerNombre,			USU.ApellidoPaterno,		USU.ApellidoMaterno,		USU.FechaNacimiento,		USU.Nacionalidad,
					USU.PaisNacimiento,			USU.EstadoNacimiento,		USU.Sexo,					USU.CURP,					USU.RazonSocial,
					USU.TipoSociedadID,			USU.RFC,					USU.RFCpm,					USU.RFCOficial,				USU.FEA,
					USU.FechaConstitucion,		USU.PaisRFC,				USU.OcupacionID,			USU.NombreCompleto,			USU.SucursalOrigen,
					USU.PaisResidencia,			USU.TipoDireccionID,		USU.EstadoID,				USU.MunicipioID,			USU.LocalidadID,
					USU.ColoniaID,				USU.Calle,					USU.NumExterior,			USU.NumInterior,			USU.CP,
					USU.NumIdenti,				USU.FecExIden,				USU.FecVenIden,				USU.DocEstanciaLegal,		USU.DocExisLegal,
					USU.FechaVenEst,			USU.EmpresaID,				USU.Usuario,				USU.FechaActual,			USU.DireccionIP,
					USU.ProgramaID,				USU.Sucursal,				USU.NumTransaccion
					FROM USUARIOSERVICIO AS USU
						WHERE USU.UsuarioServicioID = Par_ClavePersonaInv;
			END IF;
		END IF;

		-- Alta 		: 006
		-- Descripcion	: Alta de Historico de Modificaciones en el Conocimiento de la Cta
		IF(Par_TipoAlta = Alta_ConocimientoCTA) THEN
			SELECT 	HIS.DepositoCred,				HIS.RetirosCargo,				HIS.ProcRecursos,				HIS.ConcentFondo,				HIS.AdmonGtosIng,
					HIS.PagoNomina,					HIS.CtaInversion,				HIS.PagoCreditos,				HIS.MediosElectronicos,			HIS.OtroUso,
					HIS.DefineUso,					HIS.RecursoProvProp,			HIS.RecursoProvTer,				HIS.NumDepositos,				HIS.FrecDepositos,
					HIS.NumRetiros,					HIS.FrecRetiros
					INTO
					Varpld_DepositoCred,			Varpld_RetirosCargo,			Varpld_ProcRecursos,			Varpld_ConcentFondo,			Varpld_AdmonGtosIng,
					Varpld_PagoNomina,				Varpld_CtaInversion,			Varpld_PagoCreditos,			Varpld_MediosElectronicos,		Varpld_OtroUso,
					Varpld_DefineUso,				Varpld_RecursoProvProp,			Varpld_RecursoProvTer,			Varpld_NumDepositos,			Varpld_FrecDepositos,
					Varpld_NumRetiros,				Varpld_FrecRetiros
					FROM HISCONOCIMIENTOCTA AS HIS
						WHERE
							CuentaAhoID = Par_CuentaAhoID
							ORDER BY FechaActual DESC
								LIMIT 1;

			SELECT 	HIS.DepositoCred,				HIS.RetirosCargo,				HIS.ProcRecursos,				HIS.ConcentFondo,				HIS.AdmonGtosIng,
					HIS.PagoNomina,					HIS.CtaInversion,				HIS.PagoCreditos,				HIS.MediosElectronicos,			HIS.OtroUso,
					HIS.DefineUso,					HIS.RecursoProvProp,			HIS.RecursoProvTer,				HIS.NumDepositos,				HIS.FrecDepositos,
					HIS.NumRetiros,					HIS.FrecRetiros
					INTO
					Varori_DepositoCred,			Varori_RetirosCargo,			Varori_ProcRecursos,			Varori_ConcentFondo,			Varori_AdmonGtosIng,
					Varori_PagoNomina,				Varori_CtaInversion,			Varori_PagoCreditos,			Varori_MediosElectronicos,		Varori_OtroUso,
					Varori_DefineUso,				Varori_RecursoProvProp,			Varori_RecursoProvTer,			Varori_NumDepositos,			Varori_FrecDepositos,
					Varori_NumRetiros,				Varori_FrecRetiros
					FROM CONOCIMIENTOCTA AS HIS
						WHERE
							CuentaAhoID = Par_CuentaAhoID;

			SET Varpld_DepositoCred					:= IFNULL(Varpld_DepositoCred,Entero_Cero);
			SET Varpld_RetirosCargo					:= IFNULL(Varpld_RetirosCargo,Entero_Cero);
			SET Varpld_ProcRecursos 				:= IFNULL(Varpld_ProcRecursos,Cadena_Vacia);
			SET Varpld_ConcentFondo 				:= IFNULL(Varpld_ConcentFondo,Cadena_Vacia);
			SET Varpld_AdmonGtosIng 				:= IFNULL(Varpld_AdmonGtosIng,Cadena_Vacia);
			SET Varpld_PagoNomina 					:= IFNULL(Varpld_PagoNomina,Cadena_Vacia);
			SET Varpld_CtaInversion 				:= IFNULL(Varpld_CtaInversion,Cadena_Vacia);
			SET Varpld_PagoCreditos 				:= IFNULL(Varpld_PagoCreditos,Cadena_Vacia);
			SET Varpld_MediosElectronicos 			:= IFNULL(Varpld_MediosElectronicos,Cadena_Vacia);
			SET Varpld_OtroUso 						:= IFNULL(Varpld_OtroUso,Cadena_Vacia);
			SET Varpld_DefineUso 					:= IFNULL(Varpld_DefineUso,Cadena_Vacia);
			SET Varpld_RecursoProvProp 				:= IFNULL(Varpld_RecursoProvProp,Cadena_Vacia);
			SET Varpld_RecursoProvTer 				:= IFNULL(Varpld_RecursoProvTer,Cadena_Vacia);
			SET Varpld_NumDepositos 				:= IFNULL(Varpld_NumDepositos,Entero_Cero);
			SET Varpld_FrecDepositos 				:= IFNULL(Varpld_FrecDepositos,Entero_Cero);
			SET Varpld_NumRetiros 					:= IFNULL(Varpld_NumRetiros,Entero_Cero);
			SET Varpld_FrecRetiros 					:= IFNULL(Varpld_FrecRetiros,Entero_Cero);

			SET Varori_DepositoCred					:= IFNULL(Varori_DepositoCred,Entero_Cero);
			SET Varori_RetirosCargo					:= IFNULL(Varori_RetirosCargo,Entero_Cero);
			SET Varori_ProcRecursos 				:= IFNULL(Varori_ProcRecursos,Cadena_Vacia);
			SET Varori_ConcentFondo 				:= IFNULL(Varori_ConcentFondo,Cadena_Vacia);
			SET Varori_AdmonGtosIng 				:= IFNULL(Varori_AdmonGtosIng,Cadena_Vacia);
			SET Varori_PagoNomina 					:= IFNULL(Varori_PagoNomina,Cadena_Vacia);
			SET Varori_CtaInversion 				:= IFNULL(Varori_CtaInversion,Cadena_Vacia);
			SET Varori_PagoCreditos 				:= IFNULL(Varori_PagoCreditos,Cadena_Vacia);
			SET Varori_MediosElectronicos 			:= IFNULL(Varori_MediosElectronicos,Cadena_Vacia);
			SET Varori_OtroUso 						:= IFNULL(Varori_OtroUso,Cadena_Vacia);
			SET Varori_DefineUso 					:= IFNULL(Varori_DefineUso,Cadena_Vacia);
			SET Varori_RecursoProvProp 				:= IFNULL(Varori_RecursoProvProp,Cadena_Vacia);
			SET Varori_RecursoProvTer 				:= IFNULL(Varori_RecursoProvTer,Cadena_Vacia);
			SET Varori_NumDepositos 				:= IFNULL(Varori_NumDepositos,Entero_Cero);
			SET Varori_FrecDepositos 				:= IFNULL(Varori_FrecDepositos,Entero_Cero);
			SET Varori_NumRetiros 					:= IFNULL(Varori_NumRetiros,Entero_Cero);
			SET Varori_FrecRetiros 					:= IFNULL(Varori_FrecRetiros,Entero_Cero);

			IF(			Varpld_DepositoCred 		!= Varori_DepositoCred 				OR 		Varpld_RetirosCargo 		!= Varori_RetirosCargo
				OR 		Varpld_ProcRecursos 		!= Varori_ProcRecursos 				OR 		Varpld_ConcentFondo 		!= Varori_ConcentFondo
				OR 		Varpld_AdmonGtosIng 		!= Varori_AdmonGtosIng 				OR 		Varpld_PagoNomina 			!= Varori_PagoNomina
				OR		Varpld_CtaInversion 		!= Varori_CtaInversion 				OR		Varpld_PagoCreditos 		!= Varori_PagoCreditos
				OR 		Varpld_MediosElectronicos 	!= Varori_MediosElectronicos 		OR		Varpld_OtroUso 				!= Varori_OtroUso
				OR 		Varpld_DefineUso 			!= Varori_DefineUso 				OR		Varpld_RecursoProvProp 		!= Varori_RecursoProvProp
				OR		Varpld_RecursoProvTer 		!= Varori_RecursoProvTer 			OR		Varpld_NumDepositos 		!= Varori_NumDepositos
				OR		Varpld_FrecDepositos 		!= Varori_FrecDepositos 			OR		Varpld_NumRetiros 			!= Varori_NumRetiros
				OR 		Varpld_FrecRetiros 			!= Varori_FrecRetiros) THEN
				INSERT INTO HISCONOCIMIENTOCTA(
					NumTransaccionAct,		CuentaAhoID,			DepositoCred,			RetirosCargo,			ProcRecursos,
					ConcentFondo,			AdmonGtosIng,			PagoNomina,				CtaInversion,			PagoCreditos,
					MediosElectronicos,		OtroUso,				DefineUso,				RecursoProvProp,		RecursoProvTer,
					NumDepositos,			FrecDepositos,			NumRetiros,				FrecRetiros,			EmpresaID,
					Usuario,				FechaActual,			DireccionIP,			ProgramaID,				Sucursal,
					NumTransaccion)
				SELECT
					Par_NumTransaccionMod,	CuentaAhoID,			DepositoCred,			RetirosCargo,			ProcRecursos,
					ConcentFondo,			AdmonGtosIng,			PagoNomina,				CtaInversion,			PagoCreditos,
					MediosElectronicos,		OtroUso,				DefineUso,				RecursoProvProp,		RecursoProvTer,
					NumDepositos,			FrecDepositos,			NumRetiros,				FrecRetiros,			EmpresaID,
					Usuario,				FechaActual,			DireccionIP,			ProgramaID,				Sucursal,
					NumTransaccion
					FROM
						CONOCIMIENTOCTA
						WHERE
							CuentaAhoID = Par_CuentaAhoID;
			END IF;
		END IF;

		-- Alta 		: 007
		-- Descripcion	: Alta de Historico de Modificaciones de Conocimiento del usuario de servicios.
		IF (Par_TipoAlta = Alta_ConocimientoUsrServ) THEN
			SELECT
				HIS.NombreGrupo,        HIS.RFC,                HIS.Participacion,   	HIS.Nacionalidad,       HIS.RazonSocial,
				HIS.Giro,               HIS.AniosOperacion,     HIS.AniosGiro,       	HIS.PEPs,               HIS.FuncionID,
				HIS.ParentescoPEP,      HIS.NombreFamiliar,     HIS.APaternoFamiliar,	HIS.AMaternoFamiliar,   HIS.CoberturaGeografica,
				HIS.Activos,            HIS.Pasivos,            HIS.CapitalNeto,     	HIS.Importa,            HIS.DolaresImporta,
				HIS.PaisesImporta1,     HIS.PaisesImporta2,     HIS.PaisesImporta3,  	HIS.Exporta,            HIS.DolaresExporta,
				HIS.PaisesExporta1,     HIS.PaisesExporta2,		HIS.PaisesExporta3,  	HIS.PrincipalFuenteIng,	HIS.IngAproxPorMes
			INTO
				Varpld_NomGrupo,		Varpld_RFC,				Varpld_Participacion,	Varpld_Nacionalidad45,	Varpld_RazonSocial,
				Varpld_Giro,			Varpld_OperacionAnios,	Varpld_GiroAnios,		Varpld_PEPs,			Varpld_FuncionID,
				Varpld_ParentescoPEP,	Varpld_NombFamiliar,	Varpld_APaternoFam,		Varpld_AMaternoFam,		Varpld_Cober_Geograf,
				Varpld_Activos,			Varpld_Pasivos,			Varpld_Capital,			Varpld_Importa,			Varpld_DolaresImport,
				Varpld_PaisesImport,	Varpld_PaisesImport2,	Varpld_PaisesImport3,	Varpld_Exporta,			Varpld_DolaresExport,
				Varpld_PaisesExport,	Varpld_PaisesExport2,	Varpld_PaisesExport3,	Varpld_PFuenteIng,		Varpld_IngAproxMes
			FROM HISCONOCIMIENTOUSUSERV AS HIS
			WHERE HIS.UsuarioServicioID = Par_ClavePersonaInv
			ORDER BY HIS.FechaActual DESC LIMIT 1;

			SELECT
				CUS.NombreGrupo,        CUS.RFC,                CUS.Participacion,   	CUS.Nacionalidad,       CUS.RazonSocial,
				CUS.Giro,               CUS.AniosOperacion,     CUS.AniosGiro,       	CUS.PEPs,               CUS.FuncionID,
				CUS.ParentescoPEP,      CUS.NombreFamiliar,     CUS.APaternoFamiliar,	CUS.AMaternoFamiliar,   CUS.CoberturaGeografica,
				CUS.Activos,            CUS.Pasivos,            CUS.CapitalNeto,     	CUS.Importa,            CUS.DolaresImporta,
				CUS.PaisesImporta1,     CUS.PaisesImporta2,     CUS.PaisesImporta3,  	CUS.Exporta,            CUS.DolaresExporta,
				CUS.PaisesExporta1,     CUS.PaisesExporta2,		CUS.PaisesExporta3,  	CUS.PrincipalFuenteIng,	CUS.IngAproxPorMes
			INTO
				Varori_NomGrupo,		Varori_RFC,				Varori_Participacion,	Varori_Nacionalidad45,	Varori_RazonSocial,
				Varori_Giro,			Varori_OperacionAnios,	Varori_GiroAnios,		Varori_PEPs,			Varori_FuncionID,
				Varori_ParentescoPEP,	Varori_NombFamiliar,	Varori_APaternoFam,		Varori_AMaternoFam,		Varori_Cober_Geograf,
				Varori_Activos,			Varori_Pasivos,			Varori_Capital,			Varori_Importa,			Varori_DolaresImport,
				Varori_PaisesImport,	Varori_PaisesImport2,	Varori_PaisesImport3,	Varori_Exporta,			Varori_DolaresExport,
				Varori_PaisesExport,	Varori_PaisesExport2,	Varori_PaisesExport3,	Varori_PFuenteIng,		Varori_IngAproxMes
			FROM CONOCIMIENTOUSUSERV AS CUS
			WHERE CUS.UsuarioServicioID = Par_ClavePersonaInv;

			SET Varpld_NomGrupo 			:= IFNULL(Varpld_NomGrupo, Cadena_Vacia);
			SET Varpld_RFC 					:= IFNULL(Varpld_RFC, Cadena_Vacia);
			SET Varpld_Participacion 		:= IFNULL(Varpld_Participacion, Entero_Cero);
			SET Varpld_Nacionalidad45 		:= IFNULL(Varpld_Nacionalidad45, Cadena_Vacia);
			SET Varpld_RazonSocial 			:= IFNULL(Varpld_RazonSocial, Cadena_Vacia);
			SET Varpld_Giro 				:= IFNULL(Varpld_Giro, Cadena_Vacia);
			SET Varpld_OperacionAnios		:= IFNULL(Varpld_OperacionAnios, Entero_Cero);
			SET Varpld_GiroAnios			:= IFNULL(Varpld_GiroAnios, Entero_Cero);
			SET Varpld_PEPs 				:= IFNULL(Varpld_PEPs, Cadena_Vacia);
			SET Varpld_FuncionID 			:= IFNULL(Varpld_FuncionID, Entero_Cero);
			SET Varpld_ParentescoPEP 		:= IFNULL(Varpld_ParentescoPEP, Cadena_Vacia);
			SET Varpld_NombFamiliar 		:= IFNULL(Varpld_NombFamiliar, Cadena_Vacia);
			SET Varpld_APaternoFam 			:= IFNULL(Varpld_APaternoFam, Cadena_Vacia);
			SET Varpld_AMaternoFam 			:= IFNULL(Varpld_AMaternoFam, Cadena_Vacia);
			SET Varpld_Cober_Geograf 		:= IFNULL(Varpld_Cober_Geograf, Cadena_Vacia);
			SET Varpld_Activos 				:= IFNULL(Varpld_Activos, Entero_Cero);
			SET Varpld_Pasivos 				:= IFNULL(Varpld_Pasivos, Entero_Cero);
			SET Varpld_Capital 				:= IFNULL(Varpld_Capital, Entero_Cero);
			SET Varpld_Importa 				:= IFNULL(Varpld_Importa, Cadena_Vacia);
			SET Varpld_DolaresImport 		:= IFNULL(Varpld_DolaresImport, Cadena_Vacia);
			SET Varpld_PaisesImport 		:= IFNULL(Varpld_PaisesImport, Cadena_Vacia);
			SET Varpld_PaisesImport2 		:= IFNULL(Varpld_PaisesImport2, Cadena_Vacia);
			SET Varpld_PaisesImport3 		:= IFNULL(Varpld_PaisesImport3, Cadena_Vacia);
			SET Varpld_Exporta 				:= IFNULL(Varpld_Exporta, Cadena_Vacia);
			SET Varpld_DolaresExport 		:= IFNULL(Varpld_DolaresExport, Cadena_Vacia);
			SET Varpld_PaisesExport 		:= IFNULL(Varpld_PaisesExport, Cadena_Vacia);
			SET Varpld_PaisesExport2 		:= IFNULL(Varpld_PaisesExport2, Cadena_Vacia);
			SET Varpld_PaisesExport3 		:= IFNULL(Varpld_PaisesExport3, Cadena_Vacia);
			SET Varpld_PFuenteIng 			:= IFNULL(Varpld_PFuenteIng, Cadena_Vacia);
			SET Varpld_IngAproxMes 			:= IFNULL(Varpld_IngAproxMes, Cadena_Vacia);

			SET Varori_NomGrupo 			:= IFNULL(Varori_NomGrupo, Cadena_Vacia);
			SET Varori_RFC 					:= IFNULL(Varori_RFC, Cadena_Vacia);
			SET Varori_Participacion 		:= IFNULL(Varori_Participacion, Entero_Cero);
			SET Varori_Nacionalidad45 		:= IFNULL(Varori_Nacionalidad45, Cadena_Vacia);
			SET Varori_RazonSocial 			:= IFNULL(Varori_RazonSocial, Cadena_Vacia);
			SET Varori_Giro 				:= IFNULL(Varori_Giro, Cadena_Vacia);
			SET Varori_OperacionAnios		:= IFNULL(Varori_OperacionAnios, Entero_Cero);
			SET Varori_GiroAnios			:= IFNULL(Varori_GiroAnios, Entero_Cero);
			SET Varori_PEPs 				:= IFNULL(Varori_PEPs, Cadena_Vacia);
			SET Varori_FuncionID 			:= IFNULL(Varori_FuncionID, Entero_Cero);
			SET Varori_ParentescoPEP 		:= IFNULL(Varori_ParentescoPEP, Cadena_Vacia);
			SET Varori_NombFamiliar 		:= IFNULL(Varori_NombFamiliar, Cadena_Vacia);
			SET Varori_APaternoFam 			:= IFNULL(Varori_APaternoFam, Cadena_Vacia);
			SET Varori_AMaternoFam 			:= IFNULL(Varori_AMaternoFam, Cadena_Vacia);
			SET Varori_Cober_Geograf 		:= IFNULL(Varori_Cober_Geograf, Cadena_Vacia);
			SET Varori_Activos 				:= IFNULL(Varori_Activos, Entero_Cero);
			SET Varori_Pasivos 				:= IFNULL(Varori_Pasivos, Entero_Cero);
			SET Varori_Capital 				:= IFNULL(Varori_Capital, Entero_Cero);
			SET Varori_Importa 				:= IFNULL(Varori_Importa, Cadena_Vacia);
			SET Varori_DolaresImport 		:= IFNULL(Varori_DolaresImport, Cadena_Vacia);
			SET Varori_PaisesImport 		:= IFNULL(Varori_PaisesImport, Cadena_Vacia);
			SET Varori_PaisesImport2 		:= IFNULL(Varori_PaisesImport2, Cadena_Vacia);
			SET Varori_PaisesImport3 		:= IFNULL(Varori_PaisesImport3, Cadena_Vacia);
			SET Varori_Exporta 				:= IFNULL(Varori_Exporta, Cadena_Vacia);
			SET Varori_DolaresExport 		:= IFNULL(Varori_DolaresExport, Cadena_Vacia);
			SET Varori_PaisesExport 		:= IFNULL(Varori_PaisesExport, Cadena_Vacia);
			SET Varori_PaisesExport2 		:= IFNULL(Varori_PaisesExport2, Cadena_Vacia);
			SET Varori_PaisesExport3 		:= IFNULL(Varori_PaisesExport3, Cadena_Vacia);
			SET Varori_PFuenteIng 			:= IFNULL(Varori_PFuenteIng, Cadena_Vacia);
			SET Varori_IngAproxMes 			:= IFNULL(Varori_IngAproxMes, Cadena_Vacia);
			SET Varori_OperacionAnios		:= IFNULL(Varori_OperacionAnios, Entero_Cero);
			SET Varori_GiroAnios			:= IFNULL(Varori_GiroAnios, Entero_Cero);

			IF (   Varpld_NomGrupo 			!= Varori_NomGrupo 			OR		Varpld_RFC 				!= Varori_RFC
				OR Varpld_Participacion 	!= Varori_Participacion 	OR		Varpld_Nacionalidad45 	!= Varori_Nacionalidad45
				OR Varpld_RazonSocial 		!= Varori_RazonSocial 		OR		Varpld_Giro 			!= Varori_Giro
				OR Varpld_OperacionAnios	!= Varori_OperacionAnios	OR		Varpld_GiroAnios		!= Varori_GiroAnios
				OR Varpld_PEPs 				!= Varori_PEPs 				OR		Varpld_FuncionID 		!= Varori_FuncionID
				OR Varpld_ParentescoPEP 	!= Varori_ParentescoPEP 	OR		Varpld_NombFamiliar 	!= Varori_NombFamiliar
				OR Varpld_APaternoFam 		!= Varori_APaternoFam 		OR		Varpld_AMaternoFam 		!= Varori_AMaternoFam
				OR Varpld_Cober_Geograf 	!= Varori_Cober_Geograf 	OR		Varpld_Activos 			!= Varori_Activos
				OR Varpld_Pasivos 			!= Varori_Pasivos 			OR		Varpld_Capital 			!= Varori_Capital
				OR Varpld_Importa 			!= Varori_Importa 			OR		Varpld_DolaresImport 	!= Varori_DolaresImport
				OR Varpld_PaisesImport 		!= Varori_PaisesImport 		OR		Varpld_PaisesImport2 	!= Varori_PaisesImport2
				OR Varpld_PaisesImport3 	!= Varori_PaisesImport3 	OR		Varpld_Exporta 			!= Varori_Exporta
				OR Varpld_DolaresExport 	!= Varori_DolaresExport 	OR		Varpld_PaisesExport 	!= Varori_PaisesExport
				OR Varpld_PaisesExport2 	!= Varori_PaisesExport2 	OR		Varpld_PaisesExport3 	!= Varori_PaisesExport3
				OR Varpld_PFuenteIng 		!= Varori_PFuenteIng 		OR		Varpld_IngAproxMes 		!= Varori_IngAproxMes) THEN

				INSERT INTO HISCONOCIMIENTOUSUSERV (
					NumTransaccionAct,      	UsuarioServicioID,     	NombreGrupo,        	RFC,                	Participacion,
					Nacionalidad,           	RazonSocial,            	Giro,               	AniosOperacion,     	AniosGiro,
					PEPs,                   	FuncionID,              	ParentescoPEP,      	NombreFamiliar,     	APaternoFamiliar,
					AMaternoFamiliar,       	CoberturaGeografica,    	Activos,            	Pasivos,            	CapitalNeto,
					Importa,                	DolaresImporta,         	PaisesImporta1,     	PaisesImporta2,     	PaisesImporta3,
					Exporta,                	DolaresExporta,         	PaisesExporta1,     	PaisesExporta2,     	PaisesExporta3,
					PrincipalFuenteIng,     	IngAproxPorMes,         	EmpresaID,          	Usuario,            	FechaActual,
					DireccionIP,            	ProgramaID,             	Sucursal,           	NumTransaccion
				) SELECT
					Par_NumTransaccionMod,      CUS.UsuarioServicioID,     CUS.NombreGrupo,        CUS.RFC,                CUS.Participacion,
					CUS.Nacionalidad,           CUS.RazonSocial,            CUS.Giro,               CUS.AniosOperacion,     CUS.AniosGiro,
					CUS.PEPs,                   CUS.FuncionID,              CUS.ParentescoPEP,      CUS.NombreFamiliar,     CUS.APaternoFamiliar,
					CUS.AMaternoFamiliar,       CUS.CoberturaGeografica,	CUS.Activos,            CUS.Pasivos,            CUS.CapitalNeto,
					CUS.Importa,                CUS.DolaresImporta,         CUS.PaisesImporta1,     CUS.PaisesImporta2,     CUS.PaisesImporta3,
					CUS.Exporta,                CUS.DolaresExporta,         CUS.PaisesExporta1,     CUS.PaisesExporta2,     CUS.PaisesExporta3,
					CUS.PrincipalFuenteIng,     CUS.IngAproxPorMes,         CUS.EmpresaID,          CUS.Usuario,            CUS.FechaActual,
					CUS.DireccionIP,            CUS.ProgramaID,             CUS.Sucursal,           CUS.NumTransaccion
				FROM CONOCIMIENTOUSUSERV AS CUS
				WHERE CUS.UsuarioServicioID = Par_ClavePersonaInv;

			END IF;
		END IF;

		SET Par_NumErr			:= 000;
		SET Par_ErrMen			:= 'Informacion Agregada Exitosamente.';
		SET Var_Control			:= 'graba';
		SET Var_Consecutivo 	:= Par_ClavePersonaInv;
	END ManejoErrores;  -- End del Handler de Errores

	IF (Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr 	AS NumErr,
			Par_ErrMen	AS ErrMen,
			Var_Control AS control,
			Var_Consecutivo AS consecutivo;
	END IF;
END TerminaStore$$