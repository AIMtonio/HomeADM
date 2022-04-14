package seguimiento.dao;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;

import seguimiento.bean.SegtoOrigenPagoBean;

import general.dao.BaseDAO;
import herramientas.Constantes;

public class SegtoOrigenPagoDAO extends BaseDAO{

	public SegtoOrigenPagoDAO(){
		super();
	}
	
	public List listaOrigenPago(SegtoOrigenPagoBean segtoBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call SEGTOORIGENPAGOLIS(?,?,  ?,?,?,?,?,?,?);";
		Object[] parametros = {	
								segtoBean.getOrigenPagoID(),
								tipoLista,
								
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"SegtoOrigenPadoDAO.listaSegtoOrigenPago",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGTOORIGENPAGOLIS(" + Arrays.toString(parametros) + ")");
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SegtoOrigenPagoBean segtoPagoBean = new SegtoOrigenPagoBean();
				segtoPagoBean.setOrigenPagoID(resultSet.getString(1));
				segtoPagoBean.setDescripcion(resultSet.getString(2));
				return segtoPagoBean;
			}
		});
		return matches;
	}
	
}