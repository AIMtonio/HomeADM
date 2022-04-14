package soporte.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;
 
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;

import soporte.bean.OperacionesFechasBean;

public class OperacionesFechasDAO extends BaseDAO {

	public OperacionesFechasDAO() {
		super();
	}
	 
	// ------------------ Transacciones ------------------------------------------
	
	/* Suma el numero de Dias a la Fecha Especificada */
	public OperacionesFechasBean sumaDias(OperacionesFechasBean operacionesFechasBean,
										  int tipoCalculo) {
		//Query con el Store Procedure
		String query = "call FECHASCAL(?,?,?,?);";		
		Object[] parametros = {
			OperacionesFechas.conversionStrDate(operacionesFechasBean.getPrimerFecha()),
		 	Constantes.FECHA_VACIA,
		 	operacionesFechasBean.getNumeroDias(),
		 	tipoCalculo
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call FECHASCAL(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					OperacionesFechasBean fechaBean = new OperacionesFechasBean();
					fechaBean.setFechaResultado(resultSet.getString(1));			
					fechaBean.setDiasEntreFechas(resultSet.getInt(2));					
					return fechaBean;
			}
		});
				
		return matches.size() > 0 ? (OperacionesFechasBean) matches.get(0) : null;
	}

	/* Obtiene el numero de Dias entre dos Fechas */
	public OperacionesFechasBean restaFechas(OperacionesFechasBean operacionesFechasBean,
										  	 int tipoCalculo) {
		//Query con el Store Procedure
		String query = "call FECHASCAL(?,?,?,?);";		
		Object[] parametros = {
			OperacionesFechas.conversionStrDate(operacionesFechasBean.getPrimerFecha()),
			operacionesFechasBean.getSegundaFecha(),
		 	operacionesFechasBean.getNumeroDias(),
		 	tipoCalculo
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call FECHASCAL(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					OperacionesFechasBean fechaBean = new OperacionesFechasBean();
					fechaBean.setFechaResultado(resultSet.getString(1));			
					fechaBean.setDiasEntreFechas(resultSet.getInt(2));					
					return fechaBean;
			}
		});
				
		return matches.size() > 0 ? (OperacionesFechasBean) matches.get(0) : null;
	}
	
	
	/* Obtiene el numero de Dias entre dos Fechas */
	public OperacionesFechasBean fechaVencimientoDiasSiguiente(OperacionesFechasBean operacionesFechasBean, int tipoCalculo) {
		//Query con el Store Procedure
		String query = "call FECHASCAL(?,?,?,?);";		
		Object[] parametros = {
			OperacionesFechas.conversionStrDate(operacionesFechasBean.getPrimerFecha()),
			OperacionesFechas.conversionStrDate(operacionesFechasBean.getSegundaFecha()),
		 	operacionesFechasBean.getNumeroDias(),
		 	tipoCalculo
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call FECHASCAL(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					OperacionesFechasBean fechaBean = new OperacionesFechasBean();
					fechaBean.setFechaCalculada(resultSet.getString("FechaCalculada"));
					fechaBean.setFechaHabil(resultSet.getString("FechaHabil"));			
					fechaBean.setDiasEntreFechas(resultSet.getInt("DiasEntreFechas"));
					fechaBean.setEsDiaHabil(resultSet.getString("EsDiaHabil"));					
					return fechaBean;
			}
		});
				
		return matches.size() > 0 ? (OperacionesFechasBean) matches.get(0) : null;
	}
	
	
	/* Obtiene la fecha de vencimiento cuando dia inhabil es domingo */
	public OperacionesFechasBean fechaVencimientoDiasDom(OperacionesFechasBean operacionesFechasBean, int tipoCalculo) {
		//Query con el Store Procedure
		String query = "call FECHASCAL(?,?,?,?);";		
		Object[] parametros = {
			OperacionesFechas.conversionStrDate(operacionesFechasBean.getPrimerFecha()),
			OperacionesFechas.conversionStrDate(operacionesFechasBean.getSegundaFecha()),
		 	operacionesFechasBean.getNumeroDias(),
		 	tipoCalculo
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call FECHASCAL(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					OperacionesFechasBean fechaBean = new OperacionesFechasBean();
					fechaBean.setFechaCalculada(resultSet.getString("FechaCalculada"));
					fechaBean.setFechaHabil(resultSet.getString("FechaHabil"));			
					fechaBean.setDiasEntreFechas(resultSet.getInt("DiasEntreFechas"));
					fechaBean.setEsDiaHabil(resultSet.getString("EsDiaHabil"));					
					return fechaBean;
			}
		});
				
		return matches.size() > 0 ? (OperacionesFechasBean) matches.get(0) : null;
	}
	
	/* Obtiene la fecha de vencimiento, tomando en cuenta el día de pago. Para las Aportaciones*/
	public OperacionesFechasBean fechaVencimientoAport(OperacionesFechasBean operacionesFechasBean, int tipoCalculo) {
		//Query con el Store Procedure
		String query = "call FECHASAPORTCAL(?,?,?,?,?,?);";		
		Object[] parametros = {
			OperacionesFechas.conversionStrDate(operacionesFechasBean.getPrimerFecha()),
			OperacionesFechas.conversionStrDate(operacionesFechasBean.getSegundaFecha()),
		 	operacionesFechasBean.getNumeroDias(),
		 	operacionesFechasBean.getDiaInhabil(),
		 	Utileria.convierteEntero(operacionesFechasBean.getDiaPago()),
		 	tipoCalculo
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call FECHASAPORTCAL(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					OperacionesFechasBean fechaBean = new OperacionesFechasBean();
					fechaBean.setFechaCalculada(resultSet.getString("FechaCalculada"));
					fechaBean.setFechaHabil(resultSet.getString("FechaHabil"));			
					fechaBean.setDiasEntreFechas(resultSet.getInt("DiasEntreFechas"));
					fechaBean.setEsDiaHabil(resultSet.getString("EsDiaHabil"));					
					return fechaBean;
			}
		});
				
		return matches.size() > 0 ? (OperacionesFechasBean) matches.get(0) : null;
	}
	
	
}
	
