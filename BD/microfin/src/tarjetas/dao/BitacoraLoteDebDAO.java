package tarjetas.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;

import org.pentaho.reporting.libraries.formula.typing.Type;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;


import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;
import soporte.bean.FoliosAplicaBean;
import soporte.dao.FoliosAplicaDAO;
import tarjetas.bean.BitacoraLoteDebBean;
import tesoreria.bean.ResultadoCargaArchivosTesoreriaBean;
import tesoreria.bean.TesoMovsArchConciliaBean;

public class BitacoraLoteDebDAO extends BaseDAO{
	FoliosAplicaDAO foliosAplicaDAO = null;
	String saltoLinea=" <br> ";
	public BitacoraLoteDebDAO(){
		super();
	}
	int RegExitosos=0;
	int RegFallidos=0;

	public ResultadoCargaArchivosTesoreriaBean altaTarjeta(final BitacoraLoteDebBean bitacoraLoteDebBean,
			final BitacoraLoteDebBean bitacoraLote, long transaccion) {
		ResultadoCargaArchivosTesoreriaBean mensaje = new ResultadoCargaArchivosTesoreriaBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (ResultadoCargaArchivosTesoreriaBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				ResultadoCargaArchivosTesoreriaBean mensajeBean = new ResultadoCargaArchivosTesoreriaBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (ResultadoCargaArchivosTesoreriaBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call BITACORALOTEDEBALT(?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_BitCargaID",Utileria.convierteEntero(bitacoraLoteDebBean.getBitCargaID()));
									sentenciaStore.setInt("Par_ConsecutivoBit",Utileria.convierteEntero(bitacoraLoteDebBean.getConsecutivoBit()));
									sentenciaStore.setInt("Par_TipoTarjeDebID",Utileria.convierteEntero(bitacoraLote.getTipoTarjetaDebID()));
									sentenciaStore.setDate("Par_FechaRegistro",parametrosAuditoriaBean.getFecha());
									sentenciaStore.setInt("Par_UsuarioID",parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setString("Par_RutaArchivo",bitacoraLote.getRutaArchivo());
									sentenciaStore.setInt("Par_NumRegistro",Utileria.convierteEntero(bitacoraLote.getNumRegistro()));
									sentenciaStore.setString("Par_NumTarjeta",bitacoraLote.getNumTarjeta());
									sentenciaStore.setString("Par_Estatus",bitacoraLote.getEstatus());
									sentenciaStore.setString("Par_MotivoFallo",bitacoraLote.getMotivoFallo());
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());

									sentenciaStore.setString("Par_FechaVencim",bitacoraLote.getFechaVencimiento());
									sentenciaStore.setString("Par_NIP",bitacoraLote.getNip());
									sentenciaStore.setString("Par_NombreTarjeta",bitacoraLote.getNombreTarjeta());

									sentenciaStore.setInt("Par_NumFallos",bitacoraLoteDebBean.getFallo());
									sentenciaStore.setInt("Par_NumExitos",bitacoraLoteDebBean.getExito());

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									//Parametros de OutPut
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
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
									ResultadoCargaArchivosTesoreriaBean resultadoBean = new ResultadoCargaArchivosTesoreriaBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										resultadoBean.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										resultadoBean.setDescripcion(resultadosStore.getString(2));
										resultadoBean.setNombreControl(resultadosStore.getString(3));
										resultadoBean.setConsecutivoString(resultadosStore.getString(4));
										resultadoBean.setFallidos(resultadosStore.getInt(5));
										resultadoBean.setExitosos(resultadosStore.getInt(6));



									}else{
										resultadoBean.setNumero(999);
										resultadoBean.setDescripcion(Constantes.MSG_ERROR + "Alta en Bitacora");
										resultadoBean.setNombreControl(Constantes.STRING_VACIO);
										resultadoBean.setConsecutivoString(Constantes.STRING_VACIO);
									}

									return resultadoBean;
								}
							}
							);

					if(mensajeBean ==  null){
						mensajeBean = new ResultadoCargaArchivosTesoreriaBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " alta");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de tarjeta", e);
					mensajeBean.setFallidos(1);
					mensajeBean.setNumero(1);
					mensajeBean.setDescripcion(e.getCause().toString());
					mensajeBean.setNombreControl("file");
					mensajeBean.setExitosos(0);
					transaction.setRollbackOnly();
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


	// ---------------------Metodo para cargar el archivo de txt----------------------------------------




	public List<BitacoraLoteDebBean> leeArchivoBitacora (String nombreArchivo){
		RegExitosos=0;
		RegFallidos=0;
		ArrayList<BitacoraLoteDebBean> listaArchivoMovsConc = new ArrayList<BitacoraLoteDebBean>();
		BufferedReader bufferedReader;
		BufferedReader bufferedReader2;
		ResultadoCargaArchivosTesoreriaBean resultadoBean = new ResultadoCargaArchivosTesoreriaBean();
		BitacoraLoteDebBean bitacoraLoteDebBean;
		String [] arreglo = null;
		String renglon;
		String renglonNuevo;
		int		fallo=0;
		boolean bandera=false;
		int tamanioLista=1;
		try {
			bufferedReader = new BufferedReader(new FileReader(nombreArchivo));

			while ((renglon = bufferedReader.readLine())!= null && !renglon.trim().equals("")){
				if(bandera){
					tamanioLista = tamanioLista+1;
				}
			}
			bufferedReader.close();
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en leer archivo de bitacora", e);
		}

		int contador = 0;


		try {
			bufferedReader2 = new BufferedReader(new FileReader(nombreArchivo));// leer desde la primera linea
			while ((renglonNuevo = bufferedReader2.readLine())!= null && !renglonNuevo.trim().equals("")){

				contador = contador + 1;
				arreglo = renglonNuevo.split("\\,");
				bitacoraLoteDebBean = new BitacoraLoteDebBean();
				bitacoraLoteDebBean.setNumRegistro(String.valueOf(tamanioLista));
				//if(isNumeric(arreglo[0])){
				if(arreglo[0].length()==16){
					bitacoraLoteDebBean.setNumTarjeta(arreglo[0].trim());

				}
				else{
					bitacoraLoteDebBean.setMotivoFallo("Deben de ser 16 Digitos o esta vacio");
					fallo = fallo+1;
				}
				/*}
				else{
					bitacoraLoteDebBean.setMotivoFallo("No coincide con el formato numérico.");
					fallo = fallo+1;
				}
				*/
				if(!arreglo[1].isEmpty()){
					bitacoraLoteDebBean.setTipoTarjetaDebID(arreglo[1].trim());

				}
				else{
					bitacoraLoteDebBean.setMotivoFallo("El Tipo de Tarjeta esta vacio");
					fallo = fallo+1;
				}
				if(!arreglo[2].isEmpty()){
					bitacoraLoteDebBean.setFechaVencimiento(arreglo[2].trim());

				}
				else{
					bitacoraLoteDebBean.setMotivoFallo("La Fecha esta Vacia");
					fallo = fallo+1;
				}
				if(!arreglo[3].isEmpty()){
					bitacoraLoteDebBean.setNip(arreglo[3].trim());

				}
				else{
					bitacoraLoteDebBean.setMotivoFallo("El Nip esta vacio");
					fallo = fallo+1;
				}
				// Se comenta la siguiente linea para poder realizar la carga de tarjetas sin el nombre de la tarjeta
				// TODO: En el futuro se puede agregar esta validacion para tarjetas nominativas
				/*if(!arreglo[4].isEmpty()){
					bitacoraLoteDebBean.setNombreTarjeta(arreglo[4].trim());

				}
				else{'/opt/tomcat6/Archivos/layouttarjeta.txt',1,'5050505050500018','E',null,
					bitacoraLoteDebBean.setMotivoFallo("El Nombre de la tarjeta esta vacia");
					fallo = fallo+1;
				}*/


				if(fallo == 0){
					RegExitosos=RegExitosos+1;
					bitacoraLoteDebBean.setEstatus("E");
				}
				else{
					RegFallidos = RegFallidos+1;
					fallo=0;
					bitacoraLoteDebBean.setEstatus("F");
				}

				bitacoraLoteDebBean.setRutaArchivo(nombreArchivo);
				bitacoraLoteDebBean.setExito(RegExitosos);
				bitacoraLoteDebBean.setFallo(RegFallidos);
				listaArchivoMovsConc.add(bitacoraLoteDebBean);

			}
			bufferedReader2.close();
		}
		catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lee archivo de bitacora ", e);
		}

		return listaArchivoMovsConc;
	}

	public ResultadoCargaArchivosTesoreriaBean cargaArchTarjetasDeb(final BitacoraLoteDebBean bitacoraLoteDebBean, final String rutaArchivo) {
		ResultadoCargaArchivosTesoreriaBean resultado = new ResultadoCargaArchivosTesoreriaBean();
		transaccionDAO.generaNumeroTransaccion();
		resultado = (ResultadoCargaArchivosTesoreriaBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				ResultadoCargaArchivosTesoreriaBean resultadoBean = null;
				List listBitacora=leeArchivoBitacora(rutaArchivo);

				String nombreOri=rutaArchivo;
				String tokens[] = nombreOri.split("[.]");
				String extension="."+tokens[1];
				Iterator iterList=listBitacora.iterator();
				int tamanoLista= 0;
				BitacoraLoteDebBean bitacoraLote=null;
				int contador = 0;
				int exitos = 0;
				int fallidos = 0;
				String motivo ="";
				float cant=0;
				String renglon;
				boolean error = true;
				long transaccion = parametrosAuditoriaBean.getNumeroTransaccion();

				BufferedReader bufferedReader = null;
				try {
					bufferedReader = new BufferedReader(new FileReader(rutaArchivo));
				} catch (FileNotFoundException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en carga de archivo tarjetas de debito", e1);
				}
				try {
					while ((renglon = bufferedReader.readLine())!= null && !renglon.trim().equals("")){
						tamanoLista = tamanoLista+1;
					}
				} catch (IOException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en carga de archivos de tarjeta", e1);
				}

				if(extension.equals(".txt")){
					// si la lista no esta vacia quiere decir que se leyo correctamente el archivo
					if(!listBitacora.isEmpty()){
						try {
							FoliosAplicaBean foliosAplicaBean = new FoliosAplicaBean();
							foliosAplicaBean.setTabla("BITACORALOTEDEBALT");
							foliosAplicaBean =foliosAplicaDAO.consultaFolioAplicacion(foliosAplicaBean, 1);
							bitacoraLoteDebBean.setBitCargaID(foliosAplicaBean.getFolio());


							bitacoraLoteDebBean.setExito(RegExitosos);
							bitacoraLoteDebBean.setFallo(RegFallidos);

							// while para recorrer el arreglo de beans que se creo al leer el archivo
							while(iterList.hasNext()){
								contador = contador+1;
								bitacoraLoteDebBean.setConsecutivoBit(String.valueOf(contador));
								bitacoraLote=(BitacoraLoteDebBean) iterList.next();
								// alta

								if(contador ==1){
									bitacoraLoteDebBean.setExito(RegExitosos);
									bitacoraLoteDebBean.setFallo(RegFallidos);
								}

								resultadoBean= altaTarjeta(bitacoraLoteDebBean, bitacoraLote, transaccion);

								bitacoraLoteDebBean.setExito(resultadoBean.getExitosos());
								bitacoraLoteDebBean.setFallo(resultadoBean.getFallidos());
								bitacoraLoteDebBean.setRutaArchivo(bitacoraLote.getRutaArchivo());
							}

							bitacoraLoteDebBean.setExito(resultadoBean.getExitosos());
							bitacoraLoteDebBean.setFallo(resultadoBean.getFallidos());
							resultadoBean.setDescripcion("No. Tarjetas: "+tamanoLista);
						}catch (Exception e) {
							e.printStackTrace();
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en transaccion de tarjeta", e);
							switch(resultadoBean.getNumero()){
							case 0:
								resultadoBean.setNumero(999);
								break;
							case 123:
								resultadoBean.setNumero(999);
								resultadoBean.setDescripcion(resultadoBean.getDescripcion());
								break;
							case 997:
								resultadoBean.setNumero(999);
								resultadoBean.setDescripcion(resultadoBean.getDescripcion());
								break;
							default:
								resultadoBean.setNumero(999);
								resultadoBean.setDescripcion("Total Registros: "+tamanoLista+ saltoLinea+"Exitosos: 0"+saltoLinea+"Fallidos: "+
										fallidos +saltoLinea+ "Error en línea: "+ contador+saltoLinea+" Motivo: "+resultadoBean.getDescripcion());
								break;
							}
							transaction.setRollbackOnly();
						}
					}
					else{ //si no se leyo un archivo correcto devuelve el error
						resultadoBean.setNumero(999);
						resultadoBean.setDescripcion("Asegurese de Seleccionar el Archivo Correcto.");
					}
				}
				else{
					resultadoBean.setNumero(999);
					resultadoBean.setDescripcion("Error al Cargar el Archivo.");
				}
				return resultadoBean;
			}
		});

		// TODO Auto-generated method stub
		return resultado;
	}

	private static boolean isNumeric(String cadena){
		try {
			Integer.parseInt(cadena);
			return true;
		} catch (NumberFormatException nfe){

			return false;
		}
	}
	public List listaBitacoraCargaLote(BitacoraLoteDebBean bitacoraLoteDebBean, int tipoLista){
		String query = "call BITACORALOTEDEBLIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				bitacoraLoteDebBean.getBitCargaID(),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"ReporteMovimientosDAO.listaMovimientos",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call BITACORALOTEDEBLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				BitacoraLoteDebBean bitacoraBean = new BitacoraLoteDebBean();
				bitacoraBean.setConsecutivoBit(String.valueOf(resultSet.getInt("ConsecutivoBit")));
				bitacoraBean.setNumTarjeta(resultSet.getString("TarjetaDebID"));
				bitacoraBean.setMotivoFallo(resultSet.getString("MotivoFallo"));

				return bitacoraBean;
			}
		});
		return matches;
	}
	public FoliosAplicaDAO getFoliosAplicaDAO() {
		return foliosAplicaDAO;
	}
	public void setFoliosAplicaDAO(FoliosAplicaDAO foliosAplicaDAO) {
		this.foliosAplicaDAO = foliosAplicaDAO;
	}

}
