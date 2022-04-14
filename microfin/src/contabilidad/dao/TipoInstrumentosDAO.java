package contabilidad.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
 
import org.springframework.jdbc.core.RowMapper;

import contabilidad.bean.TipoInstrumentosBean;

public class TipoInstrumentosDAO extends BaseDAO{
	
		//Variables
		TipoInstrumentosDAO tipoInstrumentosDAO = null;
		
		public TipoInstrumentosDAO() {
			super();
		}
		
		/* Lista de tipo de instrumento el combo*/
		public List listaTipoInstrumentos( int tipoLista) {
			List listaTipoInstrumentos = null ;
			try{
				// Query con el Store Procedure
				String query = "call TIPOINSTRUMENTOSLIS(?,?,  ?,?,?,?,?,?,?);";
				Object[] parametros = { 
										Constantes.ENTERO_CERO,
										tipoLista,
										
										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO,
										OperacionesFechas.FEC_VACIA,
										Constantes.STRING_VACIO,
										"TipoInstrumentoDAO.listaPrincipal",
										Constantes.ENTERO_CERO, 
										Constantes.ENTERO_CERO };
				
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOINSTRUMENTOSLIS(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum)
							throws SQLException {
						TipoInstrumentosBean instrumentoBean = new TipoInstrumentosBean();
						instrumentoBean.setTipoInstrumentoID(resultSet.getString(1));
						instrumentoBean.setDescripcion(resultSet.getString(2));
						return instrumentoBean;
					}
				});
				listaTipoInstrumentos= matches;
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de tipos de instrumentos", e);
			}
			return listaTipoInstrumentos;
		}
		
		/* Lista de tipo de instrumento el combo*/
		public List lista(TipoInstrumentosBean tipoInstrumentosBean, int tipoLista) {
			List listaTipoInstrumentos = null ;
			try{
				// Query con el Store Procedure
				String query = "call TIPOINSTRUMENTOSLIS(?,?,  ?,?,?,?,?,?,?);";
				Object[] parametros = { 
										tipoInstrumentosBean.getTipoInstrumentoID(),
										tipoLista,
										
										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO,
										OperacionesFechas.FEC_VACIA,
										Constantes.STRING_VACIO,
										"TipoInstrumentoDAO.listaPrincipal",
										Constantes.ENTERO_CERO, 
										Constantes.ENTERO_CERO };
				
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOINSTRUMENTOSLIS(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum)
							throws SQLException {
						TipoInstrumentosBean instrumentoBean = new TipoInstrumentosBean();
						instrumentoBean.setTipoInstrumentoID(resultSet.getString(1));
						instrumentoBean.setDescripcion(resultSet.getString(2));
						return instrumentoBean;
					}
				});
				listaTipoInstrumentos= matches;
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de tipos de instrumentos", e);
			}
			return listaTipoInstrumentos;
		}
		
		
		//consulta de Tipo de instrumentos 
		public TipoInstrumentosBean consultaPrincipal(TipoInstrumentosBean tipoInstrumentosBean, int tipoConsulta) {			
			//Query con el Store Procedure
			String query = "call TIPOINSTRUMENTOSCON(?,?,?, ?,?,?, ?,?,?);";
			Object[] parametros = {	tipoInstrumentosBean.getTipoInstrumentoID(),
									tipoConsulta,
									
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"tipoInstrumentosDAO.consultaPrincipal",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOINSTRUMENTOSCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					TipoInstrumentosBean tipoInstrumentos = new TipoInstrumentosBean();
					tipoInstrumentos.setTipoInstrumentoID(String.valueOf(resultSet.getInt(1)));
					tipoInstrumentos.setDescripcion(resultSet.getString(2));								
						return tipoInstrumentos;
		
				}
			});
			return matches.size() > 0 ? (TipoInstrumentosBean) matches.get(0) : null;			
		}
}
