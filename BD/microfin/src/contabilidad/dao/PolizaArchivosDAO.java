package contabilidad.dao;
import general.bean.MensajeTransaccionArchivoBean;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.io.File;
import java.io.FileReader;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

import org.apache.commons.io.FileUtils;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.web.multipart.MultipartFile;

import soporte.bean.ProcesosETLBean;
import soporte.dao.ProcesosETLDAO;

import com.csvreader.CsvReader;

import contabilidad.bean.CentroCostosBean;
import contabilidad.bean.CuentasContablesBean;
import contabilidad.bean.DetallePolizaBean;
import contabilidad.bean.PolizaArchivosBean;

public class PolizaArchivosDAO extends BaseDAO {
	ParametrosSesionBean parametrosSesionBean = null;
	CentroCostosDAO centroCostosDAO=null;
	CuentasContablesDAO cuentasContablesDAO=null;
	String nombreArchivo = "";
	ProcesosETLDAO procesosETLDAO = null;

	public PolizaArchivosDAO(){
		super();
	}
	// Carga de detalle de pagos de nomina
	public MensajeTransaccionArchivoBean cargaMasivaPoliza(final PolizaArchivosBean file){
		MensajeTransaccionArchivoBean resultado = new MensajeTransaccionArchivoBean();
		MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
		try{
			transaccionDAO.generaNumeroTransaccion();
			String numTransaccion = ""+parametrosAuditoriaBean.getNumeroTransaccion();

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+" Carga Masiva Polizas: "+file.getRecurso());

			// PARAMETROS PROCESOSETL
			ProcesosETLBean procesosETLBean = new ProcesosETLBean();
			procesosETLBean.setProcesoETLID("2");//id del proceso ETL TABLA PROCESOSETL

			//consulta los parametros del ETL
			int tipoConsulta = 1;
			procesosETLBean = procesosETLDAO.conProcesoETL(procesosETLBean, tipoConsulta);

			// Guarda fisicamente en la ruta los archivos de Poliza
			resultado = guardaArchivoPolizaContable(file,procesosETLBean.getRutaCarpetaETL());
			if(resultado.getNumero() != Constantes.CODIGO_SIN_ERROR){
				return resultado;
			}

			// PARAMETROS PANTALLA
			String[] parametros = {
				numTransaccion+"", // "Par_TransaccionID",
				nombreArchivo	// Par_NombreArchivo
			};

			// EJECUCION DEL SH QUE PROCESA EL ETL
			mensajeBean = procesosETLDAO.procesarArchivoSH(procesosETLBean, parametros);
			resultado.setNumero(mensajeBean.getNumero());
			resultado.setDescripcion(mensajeBean.getDescripcion());

			if(resultado.getNumero()!=0){
				loggerSAFI.info("Error al ejecutar SH :  " + resultado.getDescripcion());
				return resultado;
			}

			resultado = procesaRegCargaPolizas(numTransaccion);
			if(resultado.getNumero()!=0){
				loggerSAFI.info("Error al intentar Procesar la carga de polizas:  " + resultado.getDescripcion());
				return resultado;
			}

			DetallePolizaBean detallePolizaBean=null;

			List listaExito = listaRegistrosCargaPolizasETL(numTransaccion,1);//registros exitosos
			List listaError = listaRegistrosCargaPolizasETL(numTransaccion,2);//registros fallidos

			String[][] arrayError = new String[listaError.size()][8];

			for(int i=0; i < listaError.size(); i++){

				detallePolizaBean = (DetallePolizaBean) listaError.get(i);

				arrayError[i][0]= detallePolizaBean.getCentroCostoID();
				arrayError[i][1]= detallePolizaBean.getCuentaCompleta();
				arrayError[i][2]= detallePolizaBean.getReferencia();
				arrayError[i][3]= detallePolizaBean.getDesCuentaCompleta();
				arrayError[i][4]= detallePolizaBean.getCargos();
				arrayError[i][5]= detallePolizaBean.getAbonos();
				arrayError[i][6]= detallePolizaBean.getDescripcion();
				arrayError[i][7]= detallePolizaBean.getDesPertenece();

			}

	        int registroTotal = listaExito.size()+listaError.size();
			int registroError = listaError.size();

			if(listaError.size() == 0){
				resultado.setDescripcion (""
						+"<table border='0'>"
						+"<tr>"
						+"<td>Registro Total: </td>"
						+"<td style='text-align:right;'>"+registroTotal+"</td>"
						+"</tr>"
						+"<tr>"
						+"<td style='text-align:right;'>"
						+"<input type='hidden' id='registroError'  name='registroError' size='26' value='"+registroError+"'/>"
						+"<input type='hidden' id='registrocsv'  name='registrocsv' size='26' value=''/></td>"
						+"<input type='hidden' id='numTransaCargaPol'  name='numTransaCargaPol' size='26' value='"+numTransaccion+"'/></td>"
						+"</tr>"
						+"</table>"
						+"");

			}else{

				String[] registro = new String[listaError.size()];

				for(int i = 0; i < listaError.size(); i++){
					int nuevafila = i+1;
					registro[i]="<tr>"
					+"<td  style='padding: 0';>"
					+"<input type='text'  id='consecutivoID"+i+"' name='consecutivoID' size='8' value='"+nuevafila+"' readonly='true' disabled='disable'/>"
					+"</td>"
					+"<td style='padding: 0'>"
					+"<input type='text'  id='centroCostoID"+i+"' name='centroCostoID' size='9' value='"+arrayError[i][0]+"' readonly='true' disabled='disable'/>"
					+"</td>"
					+"<td style='padding: 0'>"
					+"<input type='text'  id='cuentaCompleta"+i+"' name='cuentaCompleta' size='26' value='"+arrayError[i][1]+"' readonly='true' disabled='disable'/>"
					+"</td>"
					+"<td style='padding: 0'>"
					+"<input type='text'  id='motivoError"+i+"' name='motivoError' size='30' value='"+arrayError[i][7]+"' readonly='true' disabled='disable'/>"
					+"</td>"
					+"</tr>";

				}

				String output = "";

				if (registro.length > 0) {
					StringBuilder sb = new StringBuilder();
					sb.append(registro[0]);

					for (int i=1; i<registro.length; i++) {
						sb.append(registro[i]);
					}

					output = sb.toString();
				}

				resultado.setDescripcion (""
						+"<div id='csv' style='height: 200px; overflow-y: scroll;'>"
						+"<table id='miTabla' border='0' cellpadding='0' cellspacing='0' width='100%'>"
						+"<tr id='encabezadoLista'>"
							+"<th>Num</th>"
							+"<th>C.Costo</th>"
							+"<th>Cuenta</th>"
							+"<th>Error</th>"
						+"</tr>"
						+output
						+"<tr style='visibility: hidden;'>"
						+"<td style='visibility: hidden;'>"
							+"<input type='hidden' id='registroError'  name='registroError' size='26' value='"+registroError+"'/>"
							+"<input type='hidden' id='registrocsv'  name='registrocsv' size='26' value='"+Arrays.deepToString(arrayError)+"'/>"
						+"</td>"
						+"</tr>"
						+"</table>"
						+"</div>"
						+"");
			}

			// Elimina fisicamente en la ruta los archivos de Poliza
			eliminaArchivoPolizaContable(file);

		}catch(Exception e){
			if (resultado.getNumero() == 0) {
				resultado.setNumero(999);
				resultado.setDescripcion(e.getMessage());
				resultado.setNombreControl(resultado.getNombreControl());
			}

			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error Procesar datos del CSV", e);
		}

		return resultado;

	}

	//Guardar fisicamente el archivo de pagos de nomina en el directorio
	public MensajeTransaccionArchivoBean guardaArchivoPolizaContable(PolizaArchivosBean polizaArchivosBean, String directorio){
		MensajeTransaccionArchivoBean resultado = new MensajeTransaccionArchivoBean();

		//Validamos que exista un archivo
		MultipartFile archivo = polizaArchivosBean.getFile();
		if (archivo == null) {
			resultado.setNumero(1);
			resultado.setDescripcion("Especifique el archivo.");
		}

		if(directorio.isEmpty()){
			resultado.setNumero(1);
			resultado.setDescripcion("Especifique ruta carpeta ETL.");
		}
		directorio = directorio+"ARCHIVOS/";
		Date f = new Date();
		SimpleDateFormat formatoFecha = new SimpleDateFormat("dd-MM-yyyyhh:mm:ss");
		String fecha = formatoFecha.format(f);
		try{
			boolean exists = (new File(directorio)).exists();
			if(!exists){
				File aDir = new File(directorio);
				aDir.mkdir();
			}

			MultipartFile file = polizaArchivosBean.getFile();
			nombreArchivo = directorio+fecha+".csv";
			if (file != null) {
				File filespring = new File(nombreArchivo);
				FileUtils.writeByteArrayToFile(filespring, file.getBytes());
			}

		}catch(Exception e){
		}

		resultado.setNumero(Constantes.CODIGO_SIN_ERROR);
		resultado.setDescripcion("Archivo guardado exitosamente");

		return resultado;
	}

	//Guardar fisicamente el archivo de pagos de nomina en el directorio
	public void eliminaArchivoPolizaContable(PolizaArchivosBean polizaArchivosBean){
		try{

			boolean exists = (new File(nombreArchivo)).exists();

			if (exists){
				File fichero = new File(nombreArchivo);
				fichero.delete();

			}

		}catch(Exception e){
		}
	}

	// Función para leer el Archivo de Excel de Pagos de Nómina
	public List leerArchivoCsv(final PolizaArchivosBean polizaArchivosBean){

		int contadorExito = 0;
		int contadorError = 0;
		String delimitador ="|";
		ArrayList listaExito = new ArrayList();
		ArrayList listaError = new ArrayList();
		ArrayList listas	= new ArrayList();

		CentroCostosBean centroCostosBean=null;
		CuentasContablesBean cuentasContablesBean=null;
		DetallePolizaBean detallePolizaBean= null;

		boolean existe= false;

		String cuenta="";
		String sub = "";
		String ref = "";
    	String cargo = "";
    	String abono = "";
    	String descripcion = "";

		CsvReader cvsReader = null;

		try {

			File fichero = new File(nombreArchivo);
			File fichero1 = new File(nombreArchivo);
		    FileReader freader = new FileReader(fichero);
		    cvsReader = new CsvReader(freader,delimitador.charAt(0));

		    String[] headers = null;

		    // Leemos las cabeceras del fichero (primera fila).
		    if(cvsReader.readHeaders()) {

	            headers = cvsReader.getHeaders();
//	            for(int i=0;i<headers.length;i++) {
//	                 System.out.println(headers[i]);
//	             }

		    }

		    while(cvsReader.readRecord()){
		    	// Podemos usar get con el nombre de la cabecera o por posición
		    	cuenta = cvsReader.get(headers[0]);
		    	sub = cvsReader.get(headers[1]);
		    	ref = cvsReader.get(headers[2]);
		    	cargo = cvsReader.get(headers[4]);
		    	abono = cvsReader.get(headers[5]);
		    	descripcion = cvsReader.get(headers[6]);


		    	if((sub !=null) && (!sub.equals(""))){
		    		String auxCenCost="";
		    		centroCostosBean = new CentroCostosBean();
			    	centroCostosBean.setCentroCostoID(sub);
			    	centroCostosBean=centroCostosDAO.consultaPrincipal(centroCostosBean, 1);

			    	if(centroCostosBean !=null){
						auxCenCost= centroCostosBean.getCentroCostoID();
			    		existe=true;
					}else{
						existe=false;
					}

			    	if(existe){

				    	String auxCtaCte="";
				    	String auxCtaDescripcion="";
				    	String auxGrupo="";
				    	if((cuenta !=null) && (!cuenta.equals(""))){
					    	cuentasContablesBean = new CuentasContablesBean();
					    	cuentasContablesBean.setCuentaCompleta(cuenta);
					    	cuentasContablesBean=cuentasContablesDAO.consultaForanea(cuentasContablesBean,2);
				    	}

				    	if(cuentasContablesBean !=null){
				    		auxCtaCte= cuentasContablesBean.getCuentaCompleta();
					    	auxCtaDescripcion= cuentasContablesBean.getDescripcion();
					    	auxGrupo= cuentasContablesBean.getGrupo();
							if(cuenta.equals(auxCtaCte)){
								if(!auxGrupo.equals("E")){

								}else{
									existe=false;
								}
							}else{
								existe=false;
							}

						}else{
								existe=false;
						}

				    	if(existe){

				    		detallePolizaBean =new DetallePolizaBean();
				    		detallePolizaBean.setCuentaCompleta(cuenta);
				    		detallePolizaBean.setCentroCostoID(sub);
				    		detallePolizaBean.setReferencia(ref);
				    		detallePolizaBean.setDesCuentaCompleta(auxCtaDescripcion);
				    		detallePolizaBean.setCargos(cargo);
				    		detallePolizaBean.setAbonos(abono);
				    		detallePolizaBean.setDescripcion(descripcion);
				    		detallePolizaBean.setDesPertenece("Existe");

				    		listaExito.add(contadorExito,detallePolizaBean);

				    		contadorExito++;

				    	}else{

				    		detallePolizaBean =new DetallePolizaBean();
				    		detallePolizaBean.setCuentaCompleta(cuenta);
				    		detallePolizaBean.setCentroCostoID(sub);
				    		detallePolizaBean.setReferencia(ref);
				    		detallePolizaBean.setDesCuentaCompleta(" ");
				    		detallePolizaBean.setCargos(cargo);
				    		detallePolizaBean.setAbonos(abono);
				    		detallePolizaBean.setDescripcion(descripcion);
				    		if(!auxGrupo.equals("E")){
				    			detallePolizaBean.setDesPertenece("La Cuenta Contable No Existe");
				    		}else{
				    			detallePolizaBean.setDesPertenece("La Cuenta Contable es Encabezado");
				    		}


				    		listaError.add(contadorError,detallePolizaBean);

				    		contadorError++;

				    	}
			    	}else{

			    		detallePolizaBean =new DetallePolizaBean();
			    		detallePolizaBean.setCuentaCompleta(cuenta);
			    		detallePolizaBean.setCentroCostoID(sub);
			    		detallePolizaBean.setReferencia(ref);
			    		detallePolizaBean.setDesCuentaCompleta(" ");
			    		detallePolizaBean.setCargos(cargo);
			    		detallePolizaBean.setAbonos(abono);
			    		detallePolizaBean.setDescripcion(descripcion);
			    		detallePolizaBean.setDesPertenece("El Centro de Costo No Existe");

			    		listaError.add(contadorError,detallePolizaBean);

			    		contadorError++;
			    	}


		    	}


		    }

		}catch(Exception e) {

		}  finally {
			if(cvsReader!=null) {
				cvsReader.close();
			}
		}


	    listas.add(0, listaExito);
		listas.add(1, listaError);

		return listas;

	 }

	public MensajeTransaccionArchivoBean altaArchivosPoliza(final PolizaArchivosBean file) {
		MensajeTransaccionArchivoBean mensajeArchivoBean = new MensajeTransaccionArchivoBean();
		transaccionDAO.generaNumeroTransaccion();
				mensajeArchivoBean = (MensajeTransaccionArchivoBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionArchivoBean mensajeBean = new MensajeTransaccionArchivoBean();
				try {
					mensajeBean = (MensajeTransaccionArchivoBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call POLIZAARCHIVOSALT(?,?,?,?,?,  ?,?,?,?,?,   ?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_PolizaID",Utileria.convierteEntero(file.getPolizaID()));
							sentenciaStore.setString("Par_Observacion",file.getObservacion());
							sentenciaStore.setString("Par_Recurso",file.getRecurso());
							sentenciaStore.setString("Par_Extension",file.getExtension());

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;
						}
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionArchivoBean mensajeTransaccionArchivoBean = new MensajeTransaccionArchivoBean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();
								resultadosStore.next();
								mensajeTransaccionArchivoBean.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
								mensajeTransaccionArchivoBean.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccionArchivoBean.setNombreControl(resultadosStore.getString("control"));
								mensajeTransaccionArchivoBean.setConsecutivoString(resultadosStore.getString("consecutivo"));
								mensajeTransaccionArchivoBean.setRecursoOrigen(resultadosStore.getString("recurso"));
							}else{
								mensajeTransaccionArchivoBean.setNumero(999);
								mensajeTransaccionArchivoBean.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}
							return mensajeTransaccionArchivoBean;
						}
					});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionArchivoBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}

					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de poliza de archivos", e);

				}
				return mensajeBean;
			}
		});

		return mensajeArchivoBean;
	}

	// Lista de archivos de la poliza
	public List listaPolizaArchivos(PolizaArchivosBean polizaArchivosBean, int tipoLista){
		List listaGridPolizaArchivos=null;
		try{
		String query = "call POLIZAARCHIVOSLIS(?,?,?,?,?  ,?,?,?,?,?);";
		Object[] parametros = {
					Constantes.ENTERO_CERO,
					Utileria.convierteEntero(polizaArchivosBean.getPolizaID()),
					tipoLista,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					Constantes.STRING_VACIO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call POLIZAARCHIVOSLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				PolizaArchivosBean polizaArchivos = new PolizaArchivosBean();

				polizaArchivos.setPolizaArchivosID(resultSet.getString("PolizaArchivosID"));
				polizaArchivos.setPolizaID(resultSet.getString("PolizaID"));
				polizaArchivos.setArchivoPolID(resultSet.getString("ArchivoPolID"));
				polizaArchivos.setTipoDocumento(resultSet.getString("TipoDocumento"));
				polizaArchivos.setObservacion(resultSet.getString("Observacion"));
				polizaArchivos.setRecurso(resultSet.getString("Recurso"));
				return polizaArchivos;
			}
		});
		listaGridPolizaArchivos= matches;
	}catch(Exception e){
		e.printStackTrace();
		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de poliza de archivo", e);
	}
		return listaGridPolizaArchivos;

	}

	public MensajeTransaccionArchivoBean 	bajaArchivosPoliza(final PolizaArchivosBean polizaArchivosBean, final int TipoBaja) {
		MensajeTransaccionArchivoBean mensajeArchivoBean = new MensajeTransaccionArchivoBean();
				mensajeArchivoBean = (MensajeTransaccionArchivoBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionArchivoBean mensajeBean = new MensajeTransaccionArchivoBean();
				try {
					mensajeBean = (MensajeTransaccionArchivoBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute( new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call POLIZAARCHIVOSBAJ(?,?,?,?,?,  ?,?,?,?,?,   ?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_PolizaArID",Utileria.convierteEntero(polizaArchivosBean.getPolizaArchivosID()));
							sentenciaStore.setInt("Par_TipoBaja",TipoBaja);
							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Par_EmpresaID",Constantes.ENTERO_CERO);
							sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
							sentenciaStore.setString("Aud_FechaActual",Utileria.convierteFecha(Constantes.FECHA_VACIA));
							sentenciaStore.setString("Aud_DireccionIP",Constantes.STRING_VACIO);
							sentenciaStore.setString("Aud_ProgramaID",Constantes.STRING_VACIO);
							sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
							sentenciaStore.setLong("Aud_NumTransaccion",Constantes.ENTERO_CERO);

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;
						}
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionArchivoBean mensajeTransaccionArchivoBean = new MensajeTransaccionArchivoBean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();
								resultadosStore.next();
								mensajeTransaccionArchivoBean.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
								mensajeTransaccionArchivoBean.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccionArchivoBean.setNombreControl(resultadosStore.getString("control"));
								mensajeTransaccionArchivoBean.setConsecutivoString(resultadosStore.getString("consecutivo"));
							}else{
								mensajeTransaccionArchivoBean.setNumero(999);
								mensajeTransaccionArchivoBean.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}
							return mensajeTransaccionArchivoBean;
						}
					});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionArchivoBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}

					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de poliza de archivos", e);

				}
				return mensajeBean;
			}
		});

		return mensajeArchivoBean;
	}

	/*PROCESA LOS REGISTROS DE LA CARGA MASIVA DE POLIZAS */
	public MensajeTransaccionArchivoBean procesaRegCargaPolizas(final String numTransaccion) {
		MensajeTransaccionArchivoBean mensaje = new MensajeTransaccionArchivoBean();
		mensaje = (MensajeTransaccionArchivoBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionArchivoBean mensajeBean = new MensajeTransaccionArchivoBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionArchivoBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

								String query = "call TMPCARGAPOLIZASETLPRO(?,"
															  +"?,?,?, ?,?,?,?,?,?,?);"; // parametros salida y auditoria

								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setLong("Par_NumTransaccion",Utileria.convierteLong(numTransaccion));

								//Parametros de Salida
								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								//Parametros de Auditoria
								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

						        loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
								return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																											DataAccessException {
								MensajeTransaccionArchivoBean mensajeTransaccion = new MensajeTransaccionArchivoBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();


									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .PolizaArchivosDAO.procesaRegCargaPolizas");
									mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
									mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
								}

								return mensajeTransaccion;
							}
						}
					);
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionArchivoBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .PolizaArchivosDAO.procesaRegCargaPolizas");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al procesar los registros guardados por el ETL" + e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	// Lista de carga de polizas por ETL exitosas y no exitosas
	public List listaRegistrosCargaPolizasETL(String transaccion, int tipoLista){
		List listaBean = null;
		try{
			String query = "call TMPCARGAPOLIZASETLLIS(" +
								"?,?, " +
								"?,?,?,?,?,?,?);";// parametros auditoria
			Object[] parametros = {
				Utileria.convierteLong(transaccion),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"listaRegistrosCargaPolizasETL",
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TMPCARGAPOLIZASETLLIS(" + Arrays.toString(parametros) + ")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper<Object>() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					DetallePolizaBean bean = new DetallePolizaBean();

					bean.setCuentaCompleta(resultSet.getString("CuentaCompleta"));
					bean.setCentroCostoID(resultSet.getString("CentroCostoID"));
					bean.setReferencia(resultSet.getString("Referencia"));
					bean.setDesCuentaCompleta(resultSet.getString("DescripCtaCompleta"));
					bean.setCargos(resultSet.getString("Cargos"));

					bean.setAbonos(resultSet.getString("Abonos"));
					bean.setDescripcion(resultSet.getString("DescripPoliza"));
					bean.setDesPertenece(resultSet.getString("DesPertenece"));
					return bean;
				}
			});
			listaBean = matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de poliza de archivo ETL", e);
		}
		return listaBean ;
	}

	//--------GETTERS Y SETTERS---------

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

	public CentroCostosDAO getCentroCostosDAO() {
		return centroCostosDAO;
	}

	public void setCentroCostosDAO(CentroCostosDAO centroCostosDAO) {
		this.centroCostosDAO = centroCostosDAO;
	}

	public CuentasContablesDAO getCuentasContablesDAO() {
		return cuentasContablesDAO;
	}

	public void setCuentasContablesDAO(CuentasContablesDAO cuentasContablesDAO) {
		this.cuentasContablesDAO = cuentasContablesDAO;
	}
	public ProcesosETLDAO getProcesosETLDAO() {
		return procesosETLDAO;
	}
	public void setProcesosETLDAO(ProcesosETLDAO procesosETLDAO) {
		this.procesosETLDAO = procesosETLDAO;
	}



}
