package tarjetas.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
 
import tarjetas.bean.TarDebTipoAclaraBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

public class TarDebTipoAclaraDAO  extends BaseDAO{
	public TarDebTipoAclaraDAO() {
		super();
	}

	/* Lista tipo de tarjetas de Debito */
	public List listaReportes(TarDebTipoAclaraBean tarDebTipoAclaraBean, int tipoLista) {
		List listaReportes=null;
		try{
		String query = "call TARDEBTIPOSACLARALIS(?,?,?, ?,?,?, ?,?,?);";
		Object[] parametros = { 
								tarDebTipoAclaraBean.getTipoAclaracionID(),
								tipoLista,
								
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"listaReportes",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO 																								
								
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARDEBTIPOSACLARALIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				TarDebTipoAclaraBean tipoReporte = new TarDebTipoAclaraBean();
				tipoReporte.setTipoAclaracionID(resultSet.getString("TipoAclaraID"));
				tipoReporte.setDescripcion(resultSet.getString("Descripcion"));
				
				return tipoReporte;
			}
		});

		listaReportes= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de tipo de aclaraciones", e);
		}	
		return listaReportes;	
	}
}
